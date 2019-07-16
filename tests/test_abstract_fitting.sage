
### separator line ###
from .context import sagednd
import sagednd.abstract_fitting as fit

def test_tune():
    square_error(error) = error^2
    v = [1,2,3,4,5]
    f(x,a,b,c) = 3*x*a + 2*b + c
    (p,l)= fit.tune(v, square_error, f, [a,b,c], matrix([[3],[1],[4]]), 1/2,4)
    assert p == matrix([[20384954673.0],[4665379111.0],[2332689559.0]])
    assert l == 1.2714323312172494e+23

def test_update_parameters():
    p_s = matrix([1,2]).transpose()
    f(x,a,b) = a*x+b
    p_l = f.args()[1:]
    L = (f(x=1)-1)^2 + (f(x=2)-8)^2 + (f(x=3)-7)^2
    l_g = jacobian(L, p_l).transpose()
    l_r = 7
    p = fit.update_parameters(p_s, [a,b], l_g, l_r)
    assert p == matrix([[169.0],[ 58.0]])

def test_loss_gradient():
    square_error(error) = error^2
    f(x,a,b,c) = (3*x*a + 2*b + c)^2
    v = [1,2,3,4,5]
    lg = fit.loss_gradient(v, square_error, f, [a,b,c]) 
    assert lg == matrix([[48*((12*a + 2*b + c)^2 - 5)*(12*a + 2*b + c) + 36*((9*a + 2*b + c)^2 - 4)*(9*a + 2*b + c) + 24*((6*a + 2*b + c)^2 - 3)*(6*a + 2*b + c) + 12*((3*a + 2*b + c)^2 - 2)*(3*a + 2*b + c)],[8*((12*a + 2*b + c)^2 - 5)*(12*a + 2*b + c) + 8*((9*a + 2*b + c)^2 - 4)*(9*a + 2*b + c) + 8*((6*a + 2*b + c)^2 - 3)*(6*a + 2*b + c) + 8*((3*a + 2*b +c)^2 - 2)*(3*a + 2*b + c) + 8*((2*b + c)^2 - 1)*(2*b + c)],[4*((12*a + 2*b + c)^2 - 5)*(12*a + 2*b + c) + 4*((9*a + 2*b + c)^2 - 4)*(9*a + 2*b + c) + 4*((6*a + 2*b + c)^2 - 3)*(6*a + 2*b + c) + 4*((3*a + 2*b +  c)^2 - 2)*(3*a + 2*b + c) + 4*((2*b + c)^2 - 1)*(2*b + c)]])

def test_loss_function():
    square_error(error) = error^2
    f(x,a,b,c) = 3*x*a + 2*b + c
    v = [1,2,3,4,5]                                                  
    lf = fit.loss_function(v, square_error, f)
    assert lf == (12*a + 2*b + c - 5)^2 + (9*a + 2*b + c - 4)^2 + (6*a + 2*b + c - 3)^2 + (3*a + 2*b + c - 2)^2 + (2*b + c - 1)^2
