import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

import * as UserActions from '../user/user.actions';

@Component({
  selector: 'my-dashboard',
  templateUrl: './dashboard.component.html',
  styles: [`#my-logout-button { background: #F44336 }`]
})

export class DashboardComponent implements OnDestroy, OnInit {
  destroyed$: Subject<any> = new Subject<any>();

  ngOnInit() {
    // this.form.get('name').setValue(this.user.name);
  }

  ngOnDestroy() {
    this.destroyed$.next();
  }

}
