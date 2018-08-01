import { CookieService } from 'ngx-cookie-service';
import { CustomSerializer } from './reducers';
import { RouterStateSerializer } from '@ngrx/router-store';
import { TransferState } from '@angular/platform-browser';
import { UserService } from './user/user.service';
import { SessionService } from './services/session.service';
declare var APP_CONFIG;

export const APP_PROVIDERS = [
  { provide: RouterStateSerializer, useClass: CustomSerializer },
  { provide: 'AppConfig', useValue: CONFIG },
  UserService,
  TransferState,
  CookieService,
  SessionService
];
