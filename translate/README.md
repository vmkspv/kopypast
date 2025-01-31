# Translating

## New translations

To create a new translation for Kopypast:

1. Use a [PO file](https://www.gnu.org/software/gettext/manual/html_node/PO-Files.html) editor of your choice.
2. Create a new translation based on the [`kopypast.pot`](kopypast.pot) file.
3. Select the target language for the new translation.
4. Translate all strings in the editor.
5. Save the file as `<language_code>.po` in the `translate` directory.
6. Add the `Description[xx]` to [`metadata.json`](../package/metadata.json) following current format.

## Updating translations

When new strings for translation appear in the source code:

1. Run the POT file [update script](update-pot.sh):
   ```
   ./translate/update-pot.sh

   * this will automatically:
     - extract translatable strings;
     - update the kopypast.pot template;
     - compile available .po files to .mo format.
   ```
2. Open the existing `.po` file in your editor.
3. Update the translation from the new POT file.
4. Translate new strings and review existing translations.
5. Save the updated `.po` file and run script again to compile.

## Submitting changes

After creating a new translation or updating an existing one:

1. Ensure all changes are saved.
2. Create a new branch in your fork of the repository.
3. Commit the following files:
   - your `.po` file in the `translate` directory;
   - updated `metadata.json` (for new translations);
   - directory with `<lang>` name from `package/contents/locale/`.
4. Push the changes to your fork on GitHub.
5. Create a pull request to the Kopypast repository.

> *Please don't include any other language files and the `.pot` template that were modified after running `update-pot.sh` in the pull request.*

Thank you for translating this project!

---

### Technical notes

1. Translations are stored in the `translate/*.po` files.
2. Compiled `.mo` files are generated in `package/contents/locale/<lang>/LC_MESSAGES/`.
3. The package namespace is `io.github.vmkspv.kopypast`.
