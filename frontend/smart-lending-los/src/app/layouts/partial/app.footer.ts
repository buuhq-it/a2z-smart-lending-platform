import { Component } from '@angular/core';

@Component({
    standalone: true,
    selector: 'layout-footer',
    template: `
      <div class="layout-footer">
        A2Z Smart Lending by
        <a href="#" target="_blank" rel="noopener noreferrer" class="text-primary font-bold hover:underline">Team 9</a>
      </div>
    `
})
export class LayoutFooter {}
