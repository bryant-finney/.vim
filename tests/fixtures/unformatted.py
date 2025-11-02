"""Python file with formatting issues for testing ruff."""
import sys
import os
import unused_module


def badly_formatted_function(x,y,z):
    """Docstring."""
    result=x+y+z
    unused_var = 42
    if x==y:
        print("equals")
    return result


class   BadlyFormattedClass:
    """Class docstring."""
    def __init__(self,value):
        self.value=value

    def method(self,a,b):
        """Method docstring."""
        return a+b


# Line too long - this is a very long line that exceeds the recommended line length and should be wrapped or reformatted
variable_with_long_name = badly_formatted_function(1,2,3)
