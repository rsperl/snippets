#!/usr/bin/env python3 

people = [ ... list of people objects ... ]
people_by_age = sorted(people, key=lambda person: person.age)
