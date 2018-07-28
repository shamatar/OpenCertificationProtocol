/* tslint:disable: max-line-length */
import { Routes } from '@angular/router';

import { SyncComponent } from './features/sync1/sync.component';
import { NotFound404Component } from './not-found404.component';
import { HelpComponent } from './features/help/help.component';

export const routes: Routes = [
  { path: '', component: SyncComponent, pathMatch: 'full' },
  { path: 'lazy2', loadChildren: './features/lazy2/index#LazyModule' },
  { path: 'lazy3', loadChildren: './features/lazy3/index#LazyModule' },
  { path: 'help', component: HelpComponent, pathMatch: 'full' },
  { path: '**', component: NotFound404Component }
];
