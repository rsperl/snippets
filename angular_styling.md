1. `[ngStyle]={fontSize: '1em'}`
2. `[style.fontSize.em]=2`
3. `[style]={fontSize: '3em'}`
4. `style="font-size: 4em"`

---

5. `@Directive({host: {'[style.fontSize.em]': 5}})`
6. `@Directive({host: {'style': 'fontSize: 6em;'}})`

---

7. `@Component({host: {'[style.fontSize.em]': 7}})`
8. `@Component({host: {'style': 'font-size: 8em;'}})`
