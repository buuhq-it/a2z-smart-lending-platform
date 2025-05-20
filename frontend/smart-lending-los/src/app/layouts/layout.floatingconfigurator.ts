import { Component, computed, inject } from '@angular/core';
import { ButtonModule } from 'primeng/button';
import { StyleClassModule } from 'primeng/styleclass';
import { LayoutConfigurator } from './layout.configurator';
import {LayoutService} from '../core/services/layout.service';

@Component({
    selector: 'layout-floating-configurator',
    imports: [ButtonModule, StyleClassModule, LayoutConfigurator],
    template: `
        <layout-configurator />
<!--        <div class="fixed flex gap-4 top-8 right-8">-->
<!--            <p-button type="button" (onClick)="toggleDarkMode()" [rounded]="true" [icon]="isDarkTheme() ? 'pi pi-moon' : 'pi pi-sun'" severity="secondary" />-->
<!--            <div class="relative">-->
<!--                <p-button icon="pi pi-palette" pStyleClass="@next" enterFromClass="hidden" enterActiveClass="animate-scalein" leaveToClass="hidden" leaveActiveClass="animate-fadeout" [hideOnOutsideClick]="true" type="button" rounded />-->
<!--                <layout-configurator />-->
<!--            </div>-->
<!--        </div>-->
    `
})
export class LayoutFloatingConfigurator {
    LayoutService = inject(LayoutService);

    isDarkTheme = computed(() => this.LayoutService.layoutConfig().darkTheme);

    toggleDarkMode() {
        this.LayoutService.layoutConfig.update((state) => ({ ...state, darkTheme: !state.darkTheme }));
    }
}
