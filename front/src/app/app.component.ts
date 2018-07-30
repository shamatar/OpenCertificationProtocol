import { Component, ViewEncapsulation, AfterViewInit, Inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Store } from '@ngrx/store';

import { views } from './app-nav-views';
import { MOBILE } from './services/constants';

import * as fromRoot from './reducers';
import * as UserActions from './user/user.actions';
import { SessionService } from './services/session.service';
import { skip, take } from 'rxjs/operators';
import { Observable } from 'rxjs';
import { User } from './user/user.model';
// import { take, publishReplay, refCount } from 'rxjs/operators/';

@Component({
  selector: 'my-app',
  // styleUrls: ['main.scss', './app.component.scss'],
  templateUrl: './app.component.html',
  encapsulation: ViewEncapsulation.None
})

export class AppComponent implements AfterViewInit {
  mobile = MOBILE;
  views = views;
  mainUrl: string;
  user$: Observable<User>;

  constructor(
    @Inject('AppConfig') private $config,
    public $route: ActivatedRoute,
    public $router: Router,
    public $store: Store<fromRoot.AppState>,
    public $session: SessionService,
  ) {
    this.user$ = this.$store.select(state => state.user.user); // .pipe(publishReplay(1), refCount());
    $session.id$.subscribe(id => {
      if (id) { this.setInitalState(id, this.mainUrl, $config.serverUrl); }
    });
    $session.msg$.subscribe(msg => {
      switch (msg) {
        case 'confirmation':
          this.$router.navigate(['/lazy2']);
          break;
        default:
          console.error('Unkown session message!');
      }
    });
  }

  activateEvent(event) {
    if (ENV === 'development') {
      console.log('Activate Event:', event);
    }
  }

  deactivateEvent(event) {
    if (ENV === 'development') {
      console.log('Deactivate Event', event);
    }
  }

  logout() {
    this.$store.dispatch(new UserActions.Logout());
  }

  setInitalState(sessionId, mainUrl, serverUrl) {
    this.user$.pipe(take(1)).subscribe(user => {
      this.$store.dispatch(
        new UserActions.EditUser(Object.assign({}, user, { sessionId, mainUrl, serverUrl }))
      );
    });
  }

  public ngAfterViewInit() {
    if (window.location.href.indexOf('mainUrl=') === -1) {
      this.mainUrl = this.$config.mainUrl;
    } else {
      this.$route.queryParams.pipe(skip(1), take(1)).subscribe(params => {
        this.mainUrl = params.mainUrl;
      });
    }
  }
}
