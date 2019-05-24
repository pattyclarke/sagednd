
from .context import sagednd
import sagednd.dnd_ability_rolls as dndrolls

def test_dnd_ability_roll_score():
    score = dndrolls.dnd_ability_roll_score([1,2,3,4])
    #score = dnd_ability_roll_score([1,2,3,4])
    expectation = 2+3+4
    assert score == expectation

def test_get_dnd_ability_rolls():
    rolls = dndrolls.get_dnd_ability_rolls()
    element_length_expectation = 4
    assert 4 == len(rolls[0])
    
