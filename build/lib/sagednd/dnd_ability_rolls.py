r"""
DnD 5e Ability Rolls [DnD5e]

This module produces a list of all ability rolls. 
These are four consecutive rolls of six sided die.
SageMath is used for syntax, since I like it. 

The module also has a function that computes the DnD ability roll score. 
The score of an ability roll is the sum of the three highest rolls.

EXAMPLES ::

    sage: rolls = get_dnd_ability_rolls()
    sage: roll_scores = [dnd_ability_roll_score(r) for r in rolls]

REFERENCES:

.. [DnD5e] Dungeons and Dragons (5th edition),
   Wizards of the Coast,
   January 2012.

AUTHORS:

- Patrick Clarke: initial implementation
"""

# This file was *autogenerated* from the file dnd_ability_rolls.sage
from sage.all_cmdline import *   # import sage library

_sage_const_1 = Integer(1); _sage_const_7 = Integer(7); _sage_const_4 = Integer(4)
# Using json for serialization so that the file is human readable
import json

def get_dnd_ability_rolls():
    r"""
    Return the list of all possible ability rolls for a single ability.

    The rolls are read from a json file, if it exists. 
    Otherwise, the rolls are computed returned and the json file is created.

    EXAMPLES ::
    
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
        roll_number = _sage_const_1 
        while roll_number <= _sage_const_4 :
            rolls = [ r + [i] for i in range(_sage_const_1 ,_sage_const_7 ) for r in rolls]
            roll_number += _sage_const_1 
            
        # Writing JSON content to data file
        with open('dnd_ability_rolls.json', 'w') as f:
            json.dump(rolls, f, sort_keys=True)

    return rolls

def dnd_ability_roll_score(roll):
    r"""
    Returns the ability roll score of an ability roll.
    This is the sum of the top three numbers in the roll.

    EXAMPLES ::
    
        sage: rolls = get_dnd_ability_rolls()
        sage: roll_scores = [dnd_ability_roll_score(r) for r in rolls]

    TESTS ::
    
        sage: rolls = get_dnd_ability_rolls()
        sage: roll_num = len(rolls)
        sage: r = ZZ.random_element(0, roll_num)
        sage: dnd_ability_roll_score(rolls[r]) <= 18
        True
        sage: 3 <= dnd_ability_roll_score(rolls[r])
        True

    """
    return sum(roll) - min(roll)
    


