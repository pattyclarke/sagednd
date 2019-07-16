r"""
Abstract Fitting

This module provides four routines to tune the parameters of a function to reduce the value of a loss function. 
The loss function depends on a cost function. Tuning takes starting values for the parameters, and a learning rate.

Note: Specialized parameters should be a (px1)-matrix (single column) so that we can add and scale them.

Note: When the parameters are updated, they are coerced to floats. This more efficiently deals with expressions like e^7 or cos(5). 

EXAMPLES ::

        sage: square_error(err) = err^2
        sage: v = [1,2,3,4,5]               
        sage: f(x,a,b,c) = 3*x*a + 2*b + c
        sage: p_l = f.args()[1:]
        sage: s_p = matrix([[3],[1],[4]])
        sage: s_p_dict = {str(p):v for p,v in zip(p_l, s_p.list())}
        sage: s_f = f(x,**s_p_dict)
        sage: t_p = tune(v, square_error, f, p_l, s_p, 0.0022, 4)
        sage: t_p_dict = {str(p):v for p,v in zip(p_l, t_p[0].list())}
        sage: t_f = f(x,**t_p_dict)
        sage: comparison = (loss_function(v, square_error, s_f), loss_function(v, square_error, t_f))

AUTHORS:

-Patrick Clarke: initial implementation
"""

def tune(lyst, cost_funktion, free_funktion, param_lst, start_params, lrn_rate, num_steps):
    r"""
    Returns a tuple of the parameter values after updating the start parameters a given number of steps, 
    and the value of the loss function at the updated parameters.

    EXAMPLES ::

        sage: square_error(error) = error^2
        sage: v = [1,2,3,4,5]               
        sage: f(x,a,b,c) = 3*x*a + 2*b + c
        sage: p_l = f.args()[1:]
        sage: s_p = matrix([[3],[1],[4]])
        sage: s_p_dict = {str(p):v for p,v in zip(p_l, s_p.list())}
        sage: s_f = f(x,**s_p_dict)
        sage: t_p = tune(v, square_error, f, p_l, s_p, 0.1, 4)
        sage: t_p_dict = {str(p):v for p,v in zip(p_l, t_p[0].list())}
        sage: t_f = f(x,**t_p_dict)
        sage: comparison = (loss_function(v, square_error, s_f), loss_function(v, square_error, t_f))

    TESTS ::

        sage: square_error(error) = error^2 
        sage: v = [1,2,3,4,5]
        sage: f(x,a,b,c) = 3*x*a + 2*b + c
        sage: tune(v, square_error, f, [a,b,c], matrix([[3],[1],[4]]), 1/2, 4)
        (
        [20384954673.0]                        
        [ 4665379111.0]                        
        [ 2332689559.0], 1.2714323312172494e+23
        )
    """
    
    lss_grad = loss_gradient(lyst, cost_funktion, free_funktion, param_lst)
    param_spcs = start_params
    for j in range(num_steps):
        param_spcs = update_parameters(param_spcs, param_lst, lss_grad, lrn_rate)
    lss = loss_function(lyst, cost_funktion, free_funktion)
    stringified = [str(p) for p in param_lst]
    param_dict = dict(zip(stringified, param_spcs.list()))
    return (param_spcs, lss(**param_dict))

def update_parameters(param_spcs, param_lst, lss_grad, lrn_rate):
    r"""
    Returns the point obtained as a lrn_rate multiple of a step from the param_spcs point in the direction in the opposite to that to the vector field lss_grad.

    EXAMPLES ::

        sage: p_s = matrix([1,2]).transpose()
        sage: f(x,a,b) = a*x+b
        sage: p_l = f.args()[1:]
        sage: L = (f(x=1)-1)^2 + (f(x=2)-8)^2 + (f(x=3)-7)^2
        sage: l_g = jacobian(L, p_l).transpose()
        sage: l_r = 7
        sage: up = update_parameters(p_s, p_l, l_g, l_r)

    TESTS ::

        sage: p_s = matrix([1,2]).transpose()
        sage: f(x,a,b) = a*x+b
        sage: p_l = f.args()[1:]
        sage: L = (f(x=1)-1)^2 + (f(x=2)-8)^2 + (f(x=3)-7)^2
        sage: l_g = jacobian(L, p_l).transpose()
        sage: l_r = 7
        sage: update_parameters(p_s, [a,b], l_g, l_r)
        [169.0]
        [ 58.0]
    """

    eval_dict = dict(zip([str(p) for p in param_lst], param_spcs.list()))
    special_lss_grad = lss_grad(**eval_dict)
    field_at_point = matrix(special_lss_grad)
    float_field = matrix([[float(c)] for c in field_at_point.list() ])
    return param_spcs - lrn_rate * float_field



def loss_gradient(lyst, cost_funktion, free_funktion, param_lst):
    r"""
    Returns the gradient of the square error with respect to the parameters in var_lst.
    
    Caveat. A function of several variables like f(x,a,b,c) outputs f(2,a,b,c) when f(2) is called. This way, later variables automatically are treated a parameters.
    
    EXAMPLES ::                                
    
        sage: square_error(error) = error^2
        sage: v = [1,2,3,4,5]
        sage: f(x,a,b,c) = (3*x*a + 2*b + c)^2
        sage: lg = loss_gradient(v, square_error, f, [a,b,c])
    
    TESTS ::
    
        sage: square_error(error) = error^2
        sage: f(x,a,b,c) = (3*x*a + 2*b + c)^2
        sage: v = [1,2,3,4,5]
        sage: loss_gradient(v, square_error, f, [a,b,c])
        [                            48*((12*a + 2*b + c)^2 - 5)*(12*a + 2*b + c) + 36*((9*a + 2*b + c)^2 - 4)*(9*a + 2*b + c) + 24*((6*a + 2*b + c)^2 - 3)*(6*a + 2*b + c) + 12*((3*a + 2*b + c)^2 - 2)*(3*a + 2*b + c)]
        [8*((12*a + 2*b + c)^2 - 5)*(12*a + 2*b + c) + 8*((9*a + 2*b + c)^2 - 4)*(9*a + 2*b + c) + 8*((6*a + 2*b + c)^2 - 3)*(6*a + 2*b + c) + 8*((3*a + 2*b + c)^2 - 2)*(3*a + 2*b + c) + 8*((2*b + c)^2 - 1)*(2*b + c)]
        [4*((12*a + 2*b + c)^2 - 5)*(12*a + 2*b + c) + 4*((9*a + 2*b + c)^2 - 4)*(9*a + 2*b + c) + 4*((6*a + 2*b + c)^2 - 3)*(6*a + 2*b + c) + 4*((3*a + 2*b + c)^2 - 2)*(3*a + 2*b + c) + 4*((2*b + c)^2 - 1)*(2*b + c)]        
    """

    loss = loss_function(lyst, cost_funktion, free_funktion)
    jak = jacobian(loss, param_lst)
    grad = jak.transpose()
    return grad


def loss_function(lyst, cost_funktion, funktion):
    r"""
    Returns the loss function associated with funktion's approximation of lyst.
    Ultimately, the loss function is the function we want to minimize by teaking the parameters of funktion.
    
    EXAMPLES ::                                  
    
        sage: square_error(error) = error^2
        sage: f(x,a,b,c) = 3*x*a + 2*b + c
        sage: v = [1,2,3,4,5]
        sage: lf = loss_function(v, square_error, f)
    
    TESTS ::

        sage: square_error(error) = error^2
        sage: f(x,a,b,c) = 3*x*a + 2*b + c
        sage: v = [1,2,3,4,5]      
        sage: loss_function(v, square_error, f) 
        (12*a + 2*b + c - 5)^2 + (9*a + 2*b + c - 4)^2 + (6*a + 2*b + c - 3)^2 + (3*a + 2*b + c - 2)^2 + (2*b + c - 1)^2
    """
    loss = 0
    x = funktion.args()[0]
    err = 0
    for i in range(len(lyst)):
        err = funktion(x=i)-lyst[i]
        loss = loss + cost_funktion(err)
    return loss




















