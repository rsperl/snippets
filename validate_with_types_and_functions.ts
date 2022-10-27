/**
 * Percentage type
 */
 type Percentage = number & { _type_: "Percentage" };

 /**
  * 
  * @param value validates the value and converts it to a Percentage type
  * @returns value as Percentage
  */
 const abv = (value: number): Percentage => {
     if (value < 0 || value > 1) {
         throw new Error(`The value ${value} is not a valid percentage`);
     }
 
     return value as Percentage;
 };
 
 
 /**
  * test function that only accepts Percentage types
  * @param value Percentage value
  */
 function print_percentage(value: Percentage) {
     console.log(`value: ${value}`)
 }
 
 /**
  * declare a Percentage using abv
  */
 let fireball: Percentage = abv(.33);
 
 print_percentage(fireball);