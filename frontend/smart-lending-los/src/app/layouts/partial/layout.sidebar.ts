import { Component, ElementRef } from '@angular/core';
import { LayoutMenu } from './layout.menu';

@Component({
    selector: 'layout-sidebar',
    standalone: true,
    imports: [LayoutMenu],
    template: `
      <div class="layout-sidebar">
        <layout-menu></layout-menu>
      </div>
    `
})
export class LayoutSidebar {
    constructor(public el: ElementRef) {}
}
