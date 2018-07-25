/* tslint:disable: max-line-length */
import { Routes } from '@angular/router';

import { DashboardComponent } from './features/dashboard.component';
import { NotFound404Component } from './not-found404.component';
import { HelpComponent } from './features/sync/help.component';

export const routes: Routes = [
  { path: '', component: DashboardComponent, pathMatch: 'full' },
  { path: 'lazy2', loadChildren: './features/lazy2/index#LazyModule' },
  { path: 'lazy3', loadChildren: './features/lazy3/index#LazyModule' },
  { path: 'help', component: HelpComponent, pathMatch: 'full' },
  { path: '**', component: NotFound404Component }
];
