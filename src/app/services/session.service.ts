import { Injectable, Inject } from '@angular/core';
import { Socket } from 'ngx-socket-io';
import { BehaviorSubject, Observable, Subject } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { RequestBase } from './request-base';
import { skip, map } from 'rxjs/operators';

@Injectable()
export class SessionService extends RequestBase {

  readonly id$ = new BehaviorSubject(undefined);
  readonly msg$ = new Subject();

  constructor(
    @Inject('AppConfig') private config,
    private socket: Socket,
    public http: HttpClient,
  ) {
    super(http);
    socket.on('disconnect', () => { this.id$.next(undefined); });
    socket.on('connect', () => {
      this.getSession().subscribe(sessionId => {
        sessionId = JSON.parse(sessionId).id;
        this.joinRoom(sessionId);
        this.id$.next(sessionId);
      });
    });
    socket.on('session', (msg) => {
      if (msg === 'simulate_confirmation') {
        this.msg$.next('confirmation');
      } else {
        console.error('Unknown message:', msg);
      }
    });
    this.id$.pipe(skip(1)).subscribe(value => {
      console.log(`Socket connection ${value ? 'estableshed' : 'closed'}`);
    });
  }

  joinRoom(room) {
    console.log(`Entering room ${room}`);
    this.socket.emit('room', room);
  }

  leaveRoom() {
    this.socket.disconnect();
  }

  sendMessage(msg: string, event?: string) {
      if (!this.id$.value) { console.error('No session Id!'); return; }
      if (!event) {
        this.socket.emit('session', { room: this.id$.value, msg: msg});
      } else {
        this.socket.emit(event, msg);
      }
  }

  getSession(): Observable<any> {
    return this.http.get(`${this.config.serverUrl}/getSession`, {...this.optionsNoPre, responseType: 'text'});
  }

  // start(mainUrl?: string) {
  //   // this.getSession().subscribe(sessionId => this.joinRoom(JSON.parse(sessionId).id));
  // }

  getMessage() {
    return this.socket
      .fromEvent('session')
      .pipe(map((data: any) => data.msg));
  }

  simulateConfirmation() {
    this.sendMessage('simulate_confirmation');
  }
}
