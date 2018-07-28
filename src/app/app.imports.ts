import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { EffectsModule } from '@ngrx/effects';
import { StoreRouterConnectingModule } from '@ngrx/router-store';
import { StoreModule, MetaReducer } from '@ngrx/store';
import { SocketIoModule, SocketIoConfig } from 'ngx-socket-io';

import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

import { DEV_REDUCERS, syncReducers, resetOnLogout, AppState } from './reducers';
import { RouterEffects } from './effects/router';
import { UserEffects } from './user/user.effects';

export const metaReducers: MetaReducer<AppState>[] = ENV === 'development' ?
  [...DEV_REDUCERS, resetOnLogout] : [resetOnLogout];

export const APP_IMPORTS = [
  BrowserAnimationsModule,
  EffectsModule.forRoot([
    RouterEffects,
    UserEffects
  ]),
  NgbModule.forRoot(),
  // FormsModule,
  // ReactiveFormsModule,
  StoreModule.forRoot(syncReducers, { metaReducers }),
  StoreRouterConnectingModule.forRoot({
    stateKey: 'router' // name of reducer key
  }),
  SocketIoModule.forRoot((CONFIG as any).sockets as SocketIoConfig)
];
