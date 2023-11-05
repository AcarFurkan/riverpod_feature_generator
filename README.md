
#Riverpod Feature Generator

1. Now, there is no longer a need to write ref.read(provider.notifier) or ref.watch(provider) every time.
2. If you deviate from the naming conventions, you’ll get a compile error, which ensures you stick to a defined structure.

3. It handles error messages for you.

4. It manages loadings for you.

5. Because it is much simpler, it increases the readability of the code base.

##Compare
Normal implementation

Implementation with generator

