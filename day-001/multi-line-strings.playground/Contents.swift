import UIKit

let string1 = """
Multi-line strings are 🔥.
But there are quirks when it comes to formatting them.

If we don't want
line breaks to show
up in the output...

"""


let string2 = """
...then we \
need to \
esacpe \
them by using back-slashes within \
the string.
"""

print(string1)
print(string2)
