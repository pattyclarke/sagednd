r"""
DnD 5e Ability Rolls [DnD5e]

This module produces a list of all ability rolls. 
These are four consecutive rolls of six sided die.
SageMath is used for syntax, since I like it. 

The module also has a function that computes the DnD ability roll score. 
The score of an ability roll is the sum of the three highest rolls.

EXAMPLES ::

    sage: import sagednd.dnd_ability_rolls
    sage: get_dnd_ability_rolls = sagednd.dnd_ability_rolls.get_dnd_ability_rolls
    sage: dnd_ability_roll_score = sagednd.dnd_ability_rolls.dnd_ability_roll_score
    sage: rolls = get_dnd_ability_rolls()
    sage: roll_scores = [dnd_ability_roll_score(r) for r in rolls]

REFERENCES:

.. [DnD5e] Dungeons and Dragons (5th edition),
   Wizards of the Coast,
   January 2012.

AUTHORS:

- Patrick Clarke: initial implementation
"""

# Using json for serialization so that the file is human readable
import json

def get_dnd_ability_rolls():
    r"""
    Return the list of all possible ability rolls for a single ability.

    The rolls are read from a json file, if it exists. 
    Otherwise, the rolls are computed returned and the json file is created.

    EXAMPLES ::
    
    sage: load("dnd_ability_rolls.sage")                      
    sage: rolls = get_dnd_ability_rolls()

    TESTS ::
    
    sage: len(get_dnd_ability_rolls()) == 6^4
    True
    
    """
    try:
        # Reading JSON content from a file
        with open('dnd_ability_rolls.json', 'r') as f:
            rolls = json.load(f)
    except:
        rolls = [[]]
        roll_number = 1
        while roll_number <= 4:
            rolls = [ r + [i] for i in range(1,7) for r in rolls]
            roll_number += 1
            
        # Writing JSON content to data file
        with open('dnd_ability_rolls.json', 'w') as f:
            json.dump(rolls, f, sort_keys=True)

    return rolls

def dnd_ability_roll_score(roll):
    r"""
    Returns the ability roll score of an ability roll.
    This is the sum of the top three numbers in the roll.

    EXAMPLES ::
    
    sage: load("dnd_ability_rolls.sage")
    sage: rolls = get_dnd_ability_rolls()
    sage: roll_scores = [dnd_roll_score(r) for r in rolls]

    TESTS ::
    
    sage: rolls = get_dnd_ability_rolls()
    sage: roll_num = len(rolls)
    sage: r = ZZ.random_element(0, roll_num)
    sage: dnd_roll_score(rolls[r]) <= 18
    True
    sage: 3 <= dnd_roll_score(rolls[r])
    True

    """
    return sum(roll) - min(roll)
    

