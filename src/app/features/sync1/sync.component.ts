import { Component, OnDestroy, OnInit } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

import * as UserActions from '../../user/user.actions';

@Component({
  selector: 'app-page-1',
  templateUrl: './sync.component.html',
})

export class SyncComponent implements OnDestroy, OnInit {
  destroyed$: Subject<any> = new Subject<any>();

  ngOnInit() {
    // this.form.get('name').setValue(this.user.name);
  }

  ngOnDestroy() {
    this.destroyed$.next();
  }

}
