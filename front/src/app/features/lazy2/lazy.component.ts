import { Component, OnDestroy, OnInit } from '@angular/core';
import { FormGroup, FormBuilder } from '@angular/forms';

import { AppState } from '../../reducers';
import { Store } from '@ngrx/store';
import { User } from '../../user/user.model';
import { Observable, Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';

import * as UserActions from '../../user/user.actions';

@Component({
  selector: 'app-page-2',
  templateUrl: './lazy.component.html'
})

export class LazyComponent  implements OnDestroy, OnInit {
  counter: Observable<number>;
  destroyed$: Subject<any> = new Subject<any>();
  form: FormGroup;
  nameLabel = 'Enter your name';
  user: User;
  user$: Observable<User>;

  constructor(
    fb: FormBuilder,
    private store: Store<AppState>
  ) {
    this.form = fb.group({
      name: ''
    });
    this.user$ = this.store.select(state => state.user.user);
    this.user$.pipe(takeUntil(this.destroyed$))
      .subscribe(user => { this.user = user; });
  }

  clearUserData() {
    this.store.dispatch(new UserActions.EditUser(
      Object.assign({}, this.user, { }
      )));

    this.form.get('name').setValue('');
  }

  submitState() {
    this.store.dispatch(new UserActions.EditUser(
      Object.assign({}, this.user, { name: this.form.get('name').value }
      )));
  }

  ngOnInit() {
    // this.form.get('name').setValue(this.user.name);
  }

  ngOnDestroy() {
    this.destroyed$.next();
  }
}
