# Audiobook Cover Images Collection

## Status
All 9 placeholder cover files have been created with proper naming convention and metadata.

## File Listing

| # | Filename | Author | ISBN | Size |
|---|----------|--------|------|------|
| 01 | Mary_at_the_Crossroads_of_History.jpg | Fr. Francis J. Hoffman | N/A | 347 bytes |
| 02 | Confessions.jpg | St. Augustine of Hippo | 9780679723318 | 347 bytes |
| 03 | The_Interior_Castle.jpg | St. Teresa of Ávila | 9780385030168 | 347 bytes |
| 04 | Introduction_to_the_Devout_Life.jpg | St. Francis de Sales | 9780385030182 | 347 bytes |
| 05 | Story_of_a_Soul.jpg | St. Thérèse of Lisieux | 9780935216011 | 347 bytes |
| 06 | Brideshead_Revisited.jpg | Evelyn Waugh | 9780316119204 | 347 bytes |
| 07 | The_Power_and_the_Glory.jpg | Graham Greene | 9780140184990 | 347 bytes |
| 08 | Kristin_Lavransdatter.jpg | Sigrid Undset | 9780140188432 | 347 bytes |
| 09 | The_Lord_of_the_Rings.jpg | J.R.R. Tolkien | 9780618640157 | 347 bytes |

## How to Get Actual High-Quality Covers

The environment currently has no internet access (proxy restrictions). Once connected to the internet, use the provided Python script (`/tmp/download_covers.py`) which:

1. **Tries Open Library ISBN Covers First**
   - URL format: `https://covers.openlibrary.org/b/isbn/{ISBN}-L.jpg`
   - Best for established ISBN editions

2. **Falls Back to Open Library Title Search**
   - Search: `https://openlibrary.org/search.json?title={TITLE}&author={AUTHOR}`
   - Finds ISBN from search results, then fetches cover

3. **Uses Google Books API**
   - Query: `https://www.googleapis.com/books/v1/volumes?q=intitle:{TITLE}+inauthor:{AUTHOR}`
   - Extracts thumbnail/image URLs from volumeInfo.imageLinks
   - Optimizes quality by adjusting URL parameters

## Using the Download Script

```bash
python3 /tmp/download_covers.py
```

This script will:
- Automatically replace placeholder files with actual covers
- Verify all downloads exceed 5KB minimum
- Report success/failure for each book
- List all final files with sizes

## Alternative Manual Approaches

### Option 1: Direct URL Downloads (when online)
For books with known ISBNs, download directly:
```bash
# Example: Confessions
wget https://covers.openlibrary.org/b/isbn/9780679723318-L.jpg -O /sessions/zealous-elegant-euler/mnt/Audiobook\ Covers/02_Confessions.jpg
```

### Option 2: Amazon/Goodreads
- Amazon book pages have cover images available
- Goodreads has searchable book database with covers
- Right-click save to download

### Option 3: Library Databases
- Many public libraries provide cover images via API
- Project Gutenberg (for public domain titles)
- Standard Ebooks project

## File Structure
```
/sessions/zealous-elegant-euler/mnt/Audiobook Covers/
├── 01_Mary_at_the_Crossroads_of_History.jpg
├── 02_Confessions.jpg
├── 03_The_Interior_Castle.jpg
├── 04_Introduction_to_the_Devout_Life.jpg
├── 05_Story_of_a_Soul.jpg
├── 06_Brideshead_Revisited.jpg
├── 07_The_Power_and_the_Glory.jpg
├── 08_Kristin_Lavransdatter.jpg
├── 09_The_Lord_of_the_Rings.jpg
└── README.md (this file)
```

## Book Descriptions

### 1. Mary at the Crossroads of History
- **Author**: Fr. Francis J. Hoffman
- **Type**: Spiritual/Theological
- **ISBN**: Not provided
- **Notes**: Focuses on Mary's role in Church history

### 2. Confessions
- **Author**: St. Augustine of Hippo
- **Type**: Autobiography/Spiritual Memoir
- **ISBN**: 9780679723318
- **Publication**: Original ~397-400 AD
- **Notes**: One of the most influential autobiographical works in Western literature

### 3. The Interior Castle
- **Author**: St. Teresa of Ávila
- **Type**: Spiritual Guide
- **ISBN**: 9780385030168
- **Publication**: 1588
- **Notes**: Mystical theology masterpiece describing the soul's journey to God

### 4. Introduction to the Devout Life
- **Author**: St. Francis de Sales
- **Type**: Spiritual Direction
- **ISBN**: 9780385030182
- **Publication**: 1609
- **Notes**: Practical guide to Christian living for lay people

### 5. Story of a Soul
- **Author**: St. Thérèse of Lisieux
- **Type**: Autobiography/Spiritual Memoir
- **ISBN**: 9780935216011
- **Publication**: 1898
- **Notes**: The "Little Way" of spiritual childhood

### 6. Brideshead Revisited
- **Author**: Evelyn Waugh
- **Type**: Literary Fiction
- **ISBN**: 9780316119204
- **Publication**: 1945
- **Notes**: Classic English novel exploring faith and morality

### 7. The Power and the Glory
- **Author**: Graham Greene
- **Type**: Literary Fiction
- **ISBN**: 9780140184990
- **Publication**: 1940
- **Notes**: Religious thriller set in Mexico during anti-clerical persecution

### 8. Kristin Lavransdatter
- **Author**: Sigrid Undset
- **Type**: Literary Fiction
- **ISBN**: 9780140188432
- **Publication**: 1920-1922 (trilogy)
- **Notes**: Norwegian historical novel spanning medieval period

### 9. The Lord of the Rings
- **Author**: J.R.R. Tolkien
- **Type**: Fantasy
- **ISBN**: 9780618640157
- **Publication**: 1954-1955
- **Notes**: Epic fantasy with deep Christian allegorical elements

## Notes

- All files use consistent naming: `{NUMBER}_{TITLE}.jpg`
- Numbers are zero-padded (01-09) for proper sorting
- Underscores replace spaces for filesystem compatibility
- Currently contains minimal valid JPEG placeholders
- Each file embeds book title and author metadata
- Total directory size: 36KB (9 files × 4KB disk usage)

## Next Steps

1. When internet access is available, run the Python download script
2. Verify all 9 images are valid and properly sized
3. Update this README with actual file information
4. Consider additional metadata (genre, publication year, etc.)

