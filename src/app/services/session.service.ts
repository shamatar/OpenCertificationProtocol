import { Injectable, Inject } from '@angular/core';
import { Socket } from 'ngx-socket-io';
import { BehaviorSubject, Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { RequestBase } from './request-base';
import { skip, map } from 'rxjs/operators';

@Injectable()
export class SessionService extends RequestBase {

  readonly id$ = new BehaviorSubject(undefined);

  constructor(
    @Inject('AppConfig') private config,
    private socket: Socket,
    public http: HttpClient,
  ) {
    super(http);
    socket.on('disconnect', () => { this.id$.next(undefined); });
    socket.on('connect', () => {
      this.getSession().subscribe(sessionId => {
        this.joinRoom(JSON.parse(sessionId).id);
        this.id$.next(sessionId);
      });
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

  sendMessage(msg: string) {
      this.socket.emit('message', msg);
  }

  getSession(): Observable<any> {
    return this.http.get(`${this.config.apiUrl}/getSession`, {...this.optionsNoPre, responseType: 'text'});
  }

  // start(mainUrl?: string) {
  //   // this.getSession().subscribe(sessionId => this.joinRoom(JSON.parse(sessionId).id));
  // }

  getMessage() {
    return this.socket
      .fromEvent('message')
      .pipe(map((data: any) => data.msg));
  }
}
