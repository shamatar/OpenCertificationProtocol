import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

import { Store } from '@ngrx/store';
import * as fromRoot from '../../reducers';
import * as UserActions from '../../user/user.actions';
import { User } from '../../user/user.model';
import { SessionService } from '../../services/session.service';

@Component({
  selector: 'app-page-1',
  templateUrl: './sync.component.html',
})

export class SyncComponent implements OnDestroy, OnInit {
  destroyed$: Subject<any> = new Subject<any>();
  user$: Observable<User>;
  qrString: string = undefined;

  constructor (
    public $store: Store<fromRoot.AppState>,
    public $session: SessionService,
  ) {
    this.$store.select(state => state.user.user).subscribe(user => {
      if (user && user.mainUrl && user.sessionId && user.serverUrl) {
        this.qrString = JSON.stringify({
          mainURL: user.mainUrl,
          sessionId: user.sessionId,
          address: user.serverUrl + '/api/mobile/setConnection'
        });
      }
    });
  }

  login() {
    this.$session.simulateConfirmation();
  }

  ngOnInit() {
    // this.form.get('name').setValue(this.user.name);
  }

  ngOnDestroy() {
    this.destroyed$.next();
  }

}
