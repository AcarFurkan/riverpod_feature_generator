
# Riverpod Feature Generator

1. Now, there is no longer a need to write ref.read(provider.notifier) or ref.watch(provider) every time.
2. If you deviate from the naming conventions, you’ll get a compile error, which ensures you stick to a defined structure.

3. It handles error messages for you.

4. It manages loadings for you.

5. Because it is much simpler, it increases the readability of the code base.

## Compare
<table>
  <tr>
    <th>Normal Implementation</th>
    <th>Implementation with Generator</th>
  </tr>
  <tr>
    <td><img width="579" alt="Normal Implementation" src="https://github.com/AcarFurkan/riverpod_feature_generator/assets/65075121/04525a2d-bd78-4cc3-8d4f-3d3aa50803ec"></td>
    <td><img width="1277" alt="Implementation with Generator" src="https://github.com/AcarFurkan/riverpod_feature_generator/assets/65075121/8c79130e-eb89-4271-84e5-830f8bdfdf47"></td>
  </tr>
</table>

### This is a beta trial version, and I am fully open to suggestions and contributions.
