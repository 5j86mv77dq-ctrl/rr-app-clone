import { useState, useMemo } from "react";

const colors = {
  headerBg: "#3b6fa0",
  cardBg: "#4a7fb3",
  pageBg: "#f5f5f5",
  contentBg: "#ffffff",
  accent: "#3b6fa0",
  text: "#2a2a2a",
  textMuted: "#7a7a7a",
  red: "#d32f2f",
  searchBg: "rgba(255,255,255,0.15)",
  searchBgLight: "#f0f0f0",
};

const audiobooks = {
  spiritual: [
    { id: "s1", title: "Mary at the Crossroads of History", author: "Fr. Francis J. Hoffman", narrator: "Fr. Francis J. Hoffman", duration: "3h 38m", color: "#1a3a5c",
      summary: "Adam and Eve, our first parents, had free will, and their choices set in motion the entire drama of salvation history. This audiobook traces the thread of Mary's role from Genesis through Revelation, showing how the Blessed Mother stands at every crossroads of human history as a guide, intercessor, and model of faith.",
      credits: { producer: "Michael Torres", director: "Sarah Chen", editor: "James Whitfield", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
    { id: "s2", title: "Confessions", author: "St. Augustine of Hippo", narrator: "Demetrios Troy", duration: "12h 45m", color: "#5c3a1a",
      summary: "One of the most influential works in Western literature, the Confessions traces Augustine's spiritual journey from his sinful youth through his conversion to Christianity. Written as a prayer to God, this autobiography reveals the inner struggles of a brilliant mind wrestling with truth, desire, and grace.",
      credits: { producer: "Michael Torres", director: "Sarah Chen", editor: "Demetrios Troy", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
    { id: "s3", title: "The Interior Castle", author: "St. Teresa of Ávila", narrator: "Maria Santos", duration: "6h 12m", color: "#3a1a5c",
      summary: "St. Teresa of Ávila's masterpiece of mystical theology describes the soul as a castle with seven dwelling places, each representing a stage of spiritual growth. Written for her Carmelite sisters, this work remains one of the most practical and profound guides to the interior life ever composed.",
      credits: { producer: "Michael Torres", director: "James Whitfield", editor: "Maria Santos", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
    { id: "s4", title: "Introduction to the Devout Life", author: "St. Francis de Sales", narrator: "James Whitfield", duration: "8h 30m", color: "#1a5c3a",
      summary: "Written originally as a series of letters of spiritual direction, St. Francis de Sales composed this timeless guide to show that holiness is possible for everyone, not just monks and nuns. Practical, warm, and deeply human, it covers prayer, the sacraments, temptation, and the virtues needed for daily Christian living.",
      credits: { producer: "Sarah Chen", director: "Michael Torres", editor: "James Whitfield", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
    { id: "s5", title: "Story of a Soul", author: "St. Thérèse of Lisieux", narrator: "Catherine Hart", duration: "5h 55m", color: "#5c1a3a",
      summary: "The autobiography of St. Thérèse of Lisieux, written under obedience to her religious superiors, reveals her 'Little Way' of spiritual childhood — a path to holiness through small acts of love and trust in God's mercy. This intimate account became one of the most widely read spiritual books of the twentieth century.",
      credits: { producer: "Michael Torres", director: "Sarah Chen", editor: "Catherine Hart", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
  ],
  fiction: [
    { id: "f1", title: "Brideshead Revisited", author: "Evelyn Waugh", narrator: "James Whitfield", duration: "11h 20m", color: "#2a5a2a",
      summary: "Charles Ryder's enchantment with the aristocratic Flyte family and their crumbling estate, Brideshead, weaves a story of memory, beauty, faith, and the relentless pursuit of grace. Waugh's masterpiece explores how God works through even the most broken and resistant souls.",
      credits: { producer: "Michael Torres", director: "Sarah Chen", editor: "James Whitfield", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
    { id: "f2", title: "The Power and the Glory", author: "Graham Greene", narrator: "Demetrios Troy", duration: "7h 15m", color: "#4a2a1a",
      summary: "Set during the anti-clerical purges in 1930s Mexico, Greene's novel follows an unnamed 'whiskey priest' — the last remaining clergyman in the state — as he flees persecution while struggling with his own sinfulness. A devastating portrait of grace operating through human weakness.",
      credits: { producer: "Sarah Chen", director: "Michael Torres", editor: "Demetrios Troy", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
    { id: "f3", title: "Kristin Lavransdatter", author: "Sigrid Undset", narrator: "Catherine Hart", duration: "18h 40m", color: "#1a3a5c",
      summary: "Nobel Prize-winning epic set in medieval Norway, following Kristin from her sheltered childhood through a passionate and often turbulent marriage, motherhood, and ultimately a life transformed by faith. Undset's trilogy is one of the great Catholic novels of the twentieth century.",
      credits: { producer: "Michael Torres", director: "James Whitfield", editor: "Catherine Hart", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
    { id: "f4", title: "The Lord of the Rings", author: "J.R.R. Tolkien", narrator: "Martin Shaw", duration: "22h 30m", color: "#3a2a1a",
      summary: "Tolkien's epic tale of hobbits, elves, and the struggle against darkness is fundamentally a Catholic work — a story of providence, sacrifice, mercy, and the power of the small and humble to change the course of history. The greatest fantasy novel ever written, brought to life in audio.",
      credits: { producer: "Michael Torres", director: "Sarah Chen", editor: "Martin Shaw", sound: "David Park", music: "Anna Kowalski", project: "The Merry Beggars Audio" } },
  ],
};

const allBooks = [...audiobooks.spiritual, ...audiobooks.fiction];

const StaticWaveform = () => (
  <div style={{ display: "flex", alignItems: "center", gap: 2.5, height: 16 }}>
    {[40, 70, 100, 60, 30].map((h, i) => (
      <div key={i} style={{ width: 2.2, height: `${h}%`, background: "#fff", borderRadius: 1.5 }} />
    ))}
  </div>
);

const SearchBar = ({ value, onChange, placeholder, variant = "light" }) => {
  const isLight = variant === "light";
  return (
    <div style={{
      display: "flex", alignItems: "center", gap: 10, padding: "10px 14px", borderRadius: 10,
      background: isLight ? colors.searchBgLight : colors.searchBg, margin: "0 20px",
    }}>
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={isLight ? colors.textMuted : "rgba(255,255,255,0.5)"} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <circle cx="11" cy="11" r="8" /><line x1="21" y1="21" x2="16.65" y2="16.65" />
      </svg>
      <input type="text" value={value} onChange={(e) => onChange(e.target.value)} placeholder={placeholder}
        style={{ background: "none", border: "none", outline: "none", fontFamily: "'DM Sans', sans-serif", fontSize: 13, color: isLight ? colors.text : "#fff", width: "100%" }} />
      {value && (
        <div onClick={() => onChange("")} style={{
          width: 20, height: 20, borderRadius: "50%", background: isLight ? "#ddd" : "rgba(255,255,255,0.2)",
          display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", fontSize: 10,
          color: isLight ? colors.textMuted : "rgba(255,255,255,0.6)",
        }}>✕</div>
      )}
    </div>
  );
};

const SquareCover = ({ book, onClick }) => (
  <div style={{ flexShrink: 0, width: 140, cursor: "pointer" }} onClick={onClick}>
    <div style={{
      width: 140, height: 140, borderRadius: 10, position: "relative", overflow: "hidden",
      boxShadow: "0 4px 14px rgba(0,0,0,0.2)", background: `linear-gradient(145deg, ${book.color}, ${book.color}dd)`,
    }}>
      <div style={{ position: "absolute", top: 12, right: 12, opacity: 0.12, fontSize: 28, color: "#fff", fontFamily: "serif" }}>✦</div>
      <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at 30% 20%, rgba(255,255,255,0.07) 0%, transparent 60%)" }} />
      <div style={{ padding: "18px 12px", position: "relative", zIndex: 1 }}>
        <div style={{ fontFamily: "'Crimson Pro', serif", fontSize: 13, fontWeight: 700, color: "#fff", lineHeight: 1.25, textShadow: "0 1px 4px rgba(0,0,0,0.4)", display: "-webkit-box", WebkitLineClamp: 3, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{book.title}</div>
        <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 9, color: "rgba(255,255,255,0.6)", marginTop: 6 }}>{book.author}</div>
      </div>
    </div>
    <div style={{ marginTop: 8, fontFamily: "'DM Sans', sans-serif", fontSize: 11, color: colors.text, fontWeight: 500, lineHeight: 1.3, display: "-webkit-box", WebkitLineClamp: 2, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{book.title}</div>
    <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 9, color: colors.textMuted, marginTop: 2 }}>Narrated by {book.narrator}</div>
  </div>
);

const GridCover = ({ book, onClick }) => (
  <div style={{ width: "calc(50% - 7px)", cursor: "pointer", marginBottom: 18 }} onClick={onClick}>
    <div style={{
      width: "100%", paddingBottom: "100%", borderRadius: 10, position: "relative", overflow: "hidden",
      boxShadow: "0 4px 14px rgba(0,0,0,0.2)", background: `linear-gradient(145deg, ${book.color}, ${book.color}dd)`,
    }}>
      <div style={{ position: "absolute", inset: 0 }}>
        <div style={{ position: "absolute", top: 12, right: 12, opacity: 0.12, fontSize: 32, color: "#fff", fontFamily: "serif" }}>✦</div>
        <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at 30% 20%, rgba(255,255,255,0.07) 0%, transparent 60%)" }} />
        <div style={{ padding: "20px 14px", position: "relative", zIndex: 1 }}>
          <div style={{ fontFamily: "'Crimson Pro', serif", fontSize: 14, fontWeight: 700, color: "#fff", lineHeight: 1.25, textShadow: "0 1px 4px rgba(0,0,0,0.4)", display: "-webkit-box", WebkitLineClamp: 4, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{book.title}</div>
          <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 10, color: "rgba(255,255,255,0.6)", marginTop: 8 }}>{book.author}</div>
        </div>
      </div>
    </div>
    <div style={{ marginTop: 8, fontFamily: "'DM Sans', sans-serif", fontSize: 12, color: colors.text, fontWeight: 500, lineHeight: 1.3, display: "-webkit-box", WebkitLineClamp: 2, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{book.title}</div>
    <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 9, color: colors.textMuted, marginTop: 2 }}>Narrated by {book.narrator}</div>
  </div>
);

const SearchResultItem = ({ book, onClick }) => (
  <div onClick={onClick} style={{ display: "flex", gap: 12, padding: "10px 20px", cursor: "pointer", borderBottom: "1px solid #f0f0f0" }}>
    <div style={{
      width: 50, height: 50, borderRadius: 8, flexShrink: 0, overflow: "hidden",
      background: `linear-gradient(145deg, ${book.color}, ${book.color}dd)`, position: "relative",
    }}>
      <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at 30% 20%, rgba(255,255,255,0.1) 0%, transparent 60%)" }} />
      <div style={{ padding: "8px 6px", position: "relative", zIndex: 1 }}>
        <div style={{ fontFamily: "'Crimson Pro', serif", fontSize: 7, fontWeight: 700, color: "#fff", lineHeight: 1.2, display: "-webkit-box", WebkitLineClamp: 3, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{book.title}</div>
      </div>
    </div>
    <div style={{ flex: 1, minWidth: 0 }}>
      <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 13, color: colors.text, fontWeight: 600, whiteSpace: "nowrap", overflow: "hidden", textOverflow: "ellipsis" }}>{book.title}</div>
      <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 11, color: colors.textMuted, marginTop: 2 }}>{book.author}</div>
      <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 10, color: colors.textMuted, marginTop: 1 }}>{book.duration} · {book.narrator}</div>
    </div>
    <div style={{ display: "flex", alignItems: "center" }}>
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={colors.textMuted} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polyline points="9 18 15 12 9 6" /></svg>
    </div>
  </div>
);

const HorizontalRow = ({ title, subtitle, books, onSeeAll, onBookClick }) => (
  <div style={{ marginBottom: 24 }}>
    <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 14, padding: "0 20px" }}>
      <div>
        <div style={{ fontFamily: "'Crimson Pro', serif", fontSize: 19, fontWeight: 700, color: colors.text, letterSpacing: -0.3 }}>{title}</div>
        {subtitle && <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 11, color: colors.textMuted, marginTop: 2, fontStyle: "italic" }}>{subtitle}</div>}
      </div>
      <div onClick={onSeeAll} style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 11, color: colors.accent, fontWeight: 600, cursor: "pointer", letterSpacing: 0.3 }}>See All →</div>
    </div>
    <div style={{ display: "flex", gap: 14, overflowX: "auto", padding: "0 20px 8px", scrollbarWidth: "none" }} className="hide-scrollbar">
      {books.map((book, i) => <SquareCover key={i} book={book} onClick={() => onBookClick(book)} />)}
    </div>
  </div>
);

const TitleDetailPage = ({ book, onBack, onSuggest }) => (
  <div style={{ overflowY: "auto", height: "100%", paddingBottom: 140 }} className="hide-scrollbar">
    <div style={{
      background: `linear-gradient(180deg, ${colors.cardBg} 0%, ${colors.headerBg} 100%)`,
      padding: "16px 20px 28px", display: "flex", flexDirection: "column", alignItems: "center",
    }}>
      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", width: "100%", marginBottom: 20 }}>
        <div onClick={onBack} style={{ width: 34, height: 34, borderRadius: "50%", background: "rgba(255,255,255,0.2)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer" }}>
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>
        </div>
        <div style={{ width: 34, height: 34, borderRadius: "50%", background: "rgba(255,255,255,0.2)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer" }}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8" /><polyline points="16 6 12 2 8 6" /><line x1="12" y1="2" x2="12" y2="15" /></svg>
        </div>
      </div>
      <div style={{
        width: 180, height: 180, borderRadius: 12, overflow: "hidden", boxShadow: "0 8px 30px rgba(0,0,0,0.35)",
        background: `linear-gradient(145deg, ${book.color}, ${book.color}cc)`, position: "relative",
      }}>
        <div style={{ position: "absolute", top: 16, right: 16, opacity: 0.15, fontSize: 40, color: "#fff", fontFamily: "serif" }}>✦</div>
        <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at 30% 20%, rgba(255,255,255,0.1) 0%, transparent 60%)" }} />
        <div style={{ padding: "28px 18px", position: "relative", zIndex: 1 }}>
          <div style={{ fontFamily: "'Crimson Pro', serif", fontSize: 18, fontWeight: 700, color: "#fff", lineHeight: 1.2, textShadow: "0 2px 6px rgba(0,0,0,0.4)" }}>{book.title}</div>
          <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 11, color: "rgba(255,255,255,0.6)", marginTop: 10 }}>{book.author}</div>
        </div>
      </div>
      <div style={{ marginTop: 16, padding: "6px 18px", borderRadius: 20, border: "1.5px solid rgba(255,255,255,0.4)", cursor: "pointer", display: "flex", alignItems: "center", gap: 6 }}>
        <span style={{ fontSize: 10, color: "#fff" }}>▶</span>
        <span style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 12, color: "#fff", fontWeight: 500 }}>Preview</span>
      </div>
      <h2 style={{ fontFamily: "'Crimson Pro', serif", fontSize: 24, fontWeight: 700, color: "#fff", textAlign: "center", margin: "16px 0 4px", lineHeight: 1.2 }}>{book.title}</h2>
      <span style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 13, color: "rgba(255,255,255,0.6)" }}>{book.duration}</span>
      <div style={{ display: "flex", marginTop: 16, width: "100%", justifyContent: "center" }}>
        <div style={{ textAlign: "center", flex: 1, borderRight: "1px solid rgba(255,255,255,0.2)", paddingRight: 16 }}>
          <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 9, color: "rgba(255,255,255,0.5)", letterSpacing: 1, textTransform: "uppercase", marginBottom: 4 }}>By</div>
          <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 13, color: "#fff", fontWeight: 500 }}>{book.author}</div>
        </div>
        <div style={{ textAlign: "center", flex: 1, paddingLeft: 16 }}>
          <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 9, color: "rgba(255,255,255,0.5)", letterSpacing: 1, textTransform: "uppercase", marginBottom: 4 }}>Narrated By</div>
          <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 13, color: "#fff", fontWeight: 500 }}>{book.narrator}</div>
        </div>
      </div>
    </div>
    <div style={{ background: colors.contentBg, borderRadius: "20px 20px 0 0", marginTop: -12, position: "relative", zIndex: 2, padding: "24px 20px" }}>
      <div style={{
        padding: "14px 0", borderRadius: 30, background: colors.accent, textAlign: "center",
        cursor: "pointer", marginBottom: 24, boxShadow: "0 2px 10px rgba(59,111,160,0.3)",
      }}>
        <span style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 14, color: "#fff", fontWeight: 600, display: "flex", alignItems: "center", justifyContent: "center", gap: 8 }}>
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" /><polyline points="7 10 12 15 17 10" /><line x1="12" y1="15" x2="12" y2="3" /></svg>
          Download to Play
        </span>
      </div>
      <div style={{ marginBottom: 24 }}>
        <h3 style={{ fontFamily: "'Crimson Pro', serif", fontSize: 18, fontWeight: 700, color: colors.text, margin: "0 0 10px" }}>Summary</h3>
        <p style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 13, color: colors.textMuted, lineHeight: 1.65, margin: 0 }}>{book.summary}</p>
      </div>
      <div style={{ height: 1, background: "#e8e8e8", margin: "0 0 24px" }} />
      <div>
        <h3 style={{ fontFamily: "'Crimson Pro', serif", fontSize: 18, fontWeight: 700, color: colors.text, margin: "0 0 16px" }}>Details & Credits</h3>
        {[
          { label: "Producer", value: book.credits.producer },
          { label: "Director", value: book.credits.director },
          { label: "Audio Editor", value: book.credits.editor },
          { label: "Sound Design", value: book.credits.sound },
          { label: "Music", value: book.credits.music },
          { label: "Production", value: book.credits.project },
        ].map((credit, i) => (
          <div key={i} style={{
            display: "flex", justifyContent: "space-between", alignItems: "center",
            padding: "10px 0", borderBottom: i < 5 ? "1px solid #f0f0f0" : "none",
          }}>
            <span style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 12, color: colors.textMuted }}>{credit.label}</span>
            <span style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 12, color: colors.text, fontWeight: 500 }}>{credit.value}</span>
          </div>
        ))}
      </div>
      <div style={{ height: 1, background: "#e8e8e8", margin: "24px 0" }} />
      <div>
        <h3 style={{ fontFamily: "'Crimson Pro', serif", fontSize: 18, fontWeight: 700, color: colors.text, margin: "0 0 14px" }}>You Might Also Enjoy</h3>
        <div style={{ display: "flex", gap: 14 }}>
          {allBooks.filter(b => b.id !== book.id).sort(() => Math.random() - 0.5).slice(0, 2).map((rec, i) => (
            <div key={i} onClick={() => onSuggest(rec)} style={{ flex: 1, cursor: "pointer" }}>
              <div style={{
                width: "100%", paddingBottom: "100%", borderRadius: 10, position: "relative", overflow: "hidden",
                boxShadow: "0 4px 14px rgba(0,0,0,0.2)", background: `linear-gradient(145deg, ${rec.color}, ${rec.color}dd)`,
              }}>
                <div style={{ position: "absolute", inset: 0 }}>
                  <div style={{ position: "absolute", top: 10, right: 10, opacity: 0.12, fontSize: 24, color: "#fff", fontFamily: "serif" }}>✦</div>
                  <div style={{ position: "absolute", inset: 0, background: "radial-gradient(ellipse at 30% 20%, rgba(255,255,255,0.07) 0%, transparent 60%)" }} />
                  <div style={{ padding: "16px 12px", position: "relative", zIndex: 1 }}>
                    <div style={{ fontFamily: "'Crimson Pro', serif", fontSize: 12, fontWeight: 700, color: "#fff", lineHeight: 1.25, textShadow: "0 1px 4px rgba(0,0,0,0.4)", display: "-webkit-box", WebkitLineClamp: 3, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{rec.title}</div>
                    <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 9, color: "rgba(255,255,255,0.6)", marginTop: 6 }}>{rec.author}</div>
                  </div>
                </div>
              </div>
              <div style={{ marginTop: 8, fontFamily: "'DM Sans', sans-serif", fontSize: 11, color: colors.text, fontWeight: 500, lineHeight: 1.3, display: "-webkit-box", WebkitLineClamp: 2, WebkitBoxOrient: "vertical", overflow: "hidden" }}>{rec.title}</div>
              <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 9, color: colors.textMuted, marginTop: 2 }}>{rec.duration}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  </div>
);

const PageHeader = ({ title, onBack, rightElement }) => (
  <div style={{ background: colors.headerBg }}>
    <div style={{ display: "flex", alignItems: "center", gap: 12, padding: "16px 20px 14px" }}>
      <div onClick={onBack} style={{
        width: 32, height: 32, borderRadius: "50%", background: "rgba(255,255,255,0.2)",
        display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer",
      }}>
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><polyline points="15 18 9 12 15 6" /></svg>
      </div>
      <h1 style={{ fontFamily: "'Crimson Pro', serif", fontSize: 24, fontWeight: 700, color: "#fff", margin: 0, letterSpacing: -0.3, flex: 1 }}>{title}</h1>
      {rightElement}
    </div>
  </div>
);

export default function AudiobooksApp() {
  const [activeTab, setActiveTab] = useState("listen");
  const [view, setView] = useState("main");
  const [selectedBook, setSelectedBook] = useState(null);
  const [mainSearch, setMainSearch] = useState("");
  const [categorySearch, setCategorySearch] = useState("");
  const [allTitlesSearch, setAllTitlesSearch] = useState("");
  const [previousView, setPreviousView] = useState("main");

  const openBook = (book) => { setPreviousView(view); setSelectedBook(book); setView("detail"); };
  const goBack = () => {
    if (view === "detail") { setSelectedBook(null); setView(previousView); }
    else { setView("main"); setCategorySearch(""); setAllTitlesSearch(""); }
  };

  const searchBooks = (books, query) => {
    if (!query.trim()) return books;
    const q = query.toLowerCase();
    return books.filter(b => b.title.toLowerCase().includes(q) || b.author.toLowerCase().includes(q) || b.narrator.toLowerCase().includes(q));
  };

  const filteredAll = useMemo(() => mainSearch.trim() ? searchBooks(allBooks, mainSearch) : [], [mainSearch]);
  const filteredAllTitles = useMemo(() => searchBooks(allBooks, allTitlesSearch), [allTitlesSearch]);
  const isSearching = mainSearch.trim().length > 0;

  return (
    <div style={{
      width: 375, height: 812, margin: "20px auto",
      background: (view === "detail" || view === "menu") ? colors.headerBg : colors.pageBg,
      borderRadius: 40, overflow: "hidden", position: "relative",
      boxShadow: "0 20px 60px rgba(0,0,0,0.3), 0 0 0 2px rgba(0,0,0,0.08)",
      fontFamily: "'DM Sans', sans-serif",
    }}>
      <link href="https://fonts.googleapis.com/css2?family=Crimson+Pro:ital,wght@0,400;0,600;0,700;1,400&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet" />
      <style>{`.hide-scrollbar::-webkit-scrollbar{display:none}input::placeholder{color:${colors.textMuted}!important}.search-dark input::placeholder{color:rgba(255,255,255,0.4)!important}`}</style>

      {/* App header — hidden on menu view which has its own header */}
      {view !== "menu" && (
        <div style={{ height: 50, background: colors.headerBg, display: "flex", alignItems: "flex-end", justifyContent: "space-between", padding: "0 20px 6px" }}>
          <div style={{ display: "flex", alignItems: "center", gap: 8 }}>
            <div style={{ width: 28, height: 28, borderRadius: "50%", background: "rgba(255,255,255,0.2)", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 9, color: "#fff", fontWeight: 700, fontFamily: "'Crimson Pro', serif" }}>RR</div>
            <span style={{ fontFamily: "'Crimson Pro', serif", fontSize: 13, color: "#fff", fontWeight: 600, letterSpacing: 0.3 }}>relevant radio</span>
          </div>
          <span style={{ color: "rgba(255,255,255,0.6)", fontSize: 16, cursor: "pointer" }}>⚙️</span>
        </div>
      )}

      <div style={{ height: view === "menu" ? 670 : 620, overflow: "hidden" }}>
        {view === "detail" && selectedBook ? (
          <TitleDetailPage book={selectedBook} onBack={goBack} onSuggest={openBook} />
        ) : (
          <div style={{ overflowY: "auto", height: "100%", paddingBottom: 140 }} className="hide-scrollbar">

            {view === "main" && (
              <>
                <PageHeader title="Audiobooks" onBack={() => {}}
                  rightElement={
                    <div onClick={() => { setView("allTitles"); setAllTitlesSearch(""); }} style={{
                      fontFamily: "'DM Sans', sans-serif", fontSize: 12, color: "rgba(255,255,255,0.7)",
                      fontWeight: 600, cursor: "pointer", whiteSpace: "nowrap",
                    }}>All Titles →</div>
                  }
                />
                <div style={{ background: colors.headerBg, paddingBottom: 16 }} className="search-dark">
                  <SearchBar value={mainSearch} onChange={setMainSearch} placeholder="Search all titles..." variant="dark" />
                </div>

                {isSearching ? (
                  <div style={{ background: colors.contentBg, minHeight: 400 }}>
                    <div style={{ padding: "14px 20px 8px", fontFamily: "'DM Sans', sans-serif", fontSize: 12, color: colors.textMuted }}>
                      {filteredAll.length} result{filteredAll.length !== 1 ? "s" : ""} for "{mainSearch}"
                    </div>
                    {filteredAll.length > 0 ? filteredAll.map((book, i) => <SearchResultItem key={i} book={book} onClick={() => openBook(book)} />) : (
                      <div style={{ padding: "40px 20px", textAlign: "center", fontFamily: "'DM Sans', sans-serif", fontSize: 14, color: colors.textMuted }}>No audiobooks found</div>
                    )}
                  </div>
                ) : (
                  <div style={{ padding: "18px 0 0" }}>
                    <HorizontalRow title="Spiritual Reading" books={audiobooks.spiritual} onSeeAll={() => { setView("allSpiritual"); setCategorySearch(""); }} onBookClick={openBook} />
                    <HorizontalRow title="Fiction" subtitle="from The Merry Beggars" books={audiobooks.fiction} onSeeAll={() => { setView("allFiction"); setCategorySearch(""); }} onBookClick={openBook} />
                  </div>
                )}
              </>
            )}

            {(view === "allSpiritual" || view === "allFiction") && (() => {
              const categoryBooks = view === "allSpiritual" ? audiobooks.spiritual : audiobooks.fiction;
              const filtered = searchBooks(categoryBooks, categorySearch);
              return (
                <>
                  <PageHeader title={view === "allSpiritual" ? "Spiritual Reading" : "Fiction"} onBack={goBack} />
                  <div style={{ background: colors.headerBg, paddingBottom: 16 }} className="search-dark">
                    <SearchBar value={categorySearch} onChange={setCategorySearch} placeholder={`Search ${view === "allSpiritual" ? "spiritual reading" : "fiction"}...`} variant="dark" />
                  </div>
                  {filtered.length > 0 ? (
                    <div style={{ display: "flex", flexWrap: "wrap", gap: 14, padding: "16px 20px" }}>
                      {filtered.map((book, i) => <GridCover key={i} book={book} onClick={() => openBook(book)} />)}
                    </div>
                  ) : (
                    <div style={{ padding: "40px 20px", textAlign: "center", fontFamily: "'DM Sans', sans-serif", fontSize: 14, color: colors.textMuted }}>No titles found</div>
                  )}
                </>
              );
            })()}

            {view === "allTitles" && (
              <>
                <PageHeader title="All Titles" onBack={goBack} />
                <div style={{ background: colors.headerBg, paddingBottom: 16 }} className="search-dark">
                  <SearchBar value={allTitlesSearch} onChange={setAllTitlesSearch} placeholder="Search all titles..." variant="dark" />
                </div>
                {filteredAllTitles.length > 0 ? (
                  <div style={{ display: "flex", flexWrap: "wrap", gap: 14, padding: "16px 20px" }}>
                    {filteredAllTitles.map((book, i) => <GridCover key={i} book={book} onClick={() => openBook(book)} />)}
                  </div>
                ) : (
                  <div style={{ padding: "40px 20px", textAlign: "center", fontFamily: "'DM Sans', sans-serif", fontSize: 14, color: colors.textMuted }}>No titles found</div>
                )}
              </>
            )}

            {view === "menu" && (() => {
              const menuItems = [
                {
                  label: "Prayer Requests",
                  icon: <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/><path d="M8.56 2.75c4.37 6.03 6.02 9.42 8.03 17.72m2.54-15.38c-3.72 4.35-8.94 5.66-16.88 5.85m19.5 1.9c-3.5-.93-6.63-.82-8.94 0-2.58.92-5.01 2.86-7.44 6.32"/></svg>,
                },
                {
                  label: "Find a Station",
                  icon: <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12.55a11 11 0 0 1 14.08 0"/><path d="M1.42 9a16 16 0 0 1 21.16 0"/><path d="M8.53 16.11a6 6 0 0 1 6.95 0"/><circle cx="12" cy="20" r="1" fill="#fff"/></svg>,
                },
                {
                  label: "Give Now",
                  icon: <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>,
                },
                {
                  label: "Live Show Schedule",
                  icon: <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>,
                },
                {
                  label: "Contact",
                  icon: <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.61 3.36 2 2 0 0 1 3.59 1h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L7.91 8.56a16 16 0 0 0 5.55 5.55l.92-.92a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z"/></svg>,
                },
                {
                  label: "Parish Ambassadors",
                  icon: <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>,
                },
              ];
              return (
                <div style={{ background: "#2a5080", minHeight: "100%", paddingBottom: 20 }}>
                  {/* Menu header */}
                  <div style={{
                    background: "linear-gradient(180deg, #3b6fa0 0%, #2e5a8a 100%)",
                    padding: "24px 20px 20px",
                    display: "flex", flexDirection: "column", alignItems: "center", gap: 6,
                  }}>
                    <div style={{ display: "flex", justifyContent: "flex-end", width: "100%", marginBottom: 4 }}>
                      <span style={{ color: "rgba(255,255,255,0.55)", fontSize: 18, cursor: "pointer" }}>⚙️</span>
                    </div>
                    {/* RR Logo */}
                    <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}>
                      <div style={{ width: 54, height: 54, borderRadius: "50%", background: "rgba(255,255,255,0.15)", display: "flex", alignItems: "center", justifyContent: "center" }}>
                        <span style={{ fontFamily: "'Crimson Pro', serif", fontSize: 20, color: "#fff", fontWeight: 700 }}>RR</span>
                      </div>
                      <span style={{ fontFamily: "'Crimson Pro', serif", fontSize: 20, color: "#fff", fontWeight: 700, letterSpacing: 0.5 }}>relevant radio</span>
                    </div>
                  </div>

                  {/* Menu items */}
                  <div style={{ padding: "16px 16px 12px", display: "flex", flexDirection: "column", gap: 10 }}>
                    {menuItems.map((item, i) => (
                      <div key={i} style={{
                        display: "flex", alignItems: "center", gap: 16,
                        background: "rgba(255,255,255,0.12)",
                        borderRadius: 12, padding: "14px 18px",
                        cursor: "pointer", border: "1px solid rgba(255,255,255,0.08)",
                      }}>
                        <div style={{ flexShrink: 0 }}>{item.icon}</div>
                        <span style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 16, fontWeight: 600, color: "#fff", flex: 1 }}>{item.label}</span>
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.4)" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                          <polyline points="9 18 15 12 9 6" />
                        </svg>
                      </div>
                    ))}
                  </div>

                  {/* Promotional banner */}
                  <div style={{ margin: "6px 16px 0", borderRadius: 12, overflow: "hidden", boxShadow: "0 4px 16px rgba(0,0,0,0.25)" }}>
                    <div style={{
                      background: "linear-gradient(135deg, #1a4a7a 0%, #2d6ca8 50%, #c9a227 100%)",
                      padding: "14px 16px", display: "flex", alignItems: "center", gap: 12,
                    }}>
                      <div style={{ width: 44, height: 44, borderRadius: 8, background: "rgba(255,255,255,0.15)", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
                        <span style={{ fontFamily: "'Crimson Pro', serif", fontSize: 13, color: "#fff", fontWeight: 700 }}>RR</span>
                      </div>
                      <div style={{ flex: 1 }}>
                        <div style={{ fontFamily: "'Crimson Pro', serif", fontSize: 15, fontWeight: 700, color: "#fff", lineHeight: 1.2 }}>Holy Land Pilgrimage</div>
                        <div style={{ fontFamily: "'DM Sans', sans-serif", fontSize: 10, color: "rgba(255,255,255,0.75)", marginTop: 2 }}>with Fr. Rocky · October 12–21, 2026</div>
                      </div>
                      <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="rgba(255,255,255,0.7)" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                        <circle cx="12" cy="12" r="10"/><polygon points="10 8 16 12 10 16 10 8" fill="rgba(255,255,255,0.7)" stroke="none"/>
                      </svg>
                    </div>
                  </div>
                </div>
              );
            })()}
          </div>
        )}
      </div>

      {/* Now Playing */}
      <div style={{
        position: "absolute", bottom: 68, left: 12, right: 12,
        background: "linear-gradient(135deg, #1b5e20, #2e7d32)", borderRadius: 12, padding: "10px 14px",
        display: "flex", alignItems: "center", justifyContent: "space-between", boxShadow: "0 4px 20px rgba(0,0,0,0.3)", zIndex: 10,
      }}>
        <div style={{ display: "flex", alignItems: "center", gap: 10 }}>
          <div style={{ width: 34, height: 34, borderRadius: 6, background: "rgba(255,255,255,0.15)", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14 }}>🎙️</div>
          <div>
            <div style={{ fontSize: 10, color: "#fff", fontWeight: 600 }}>LISTEN LIVE</div>
            <div style={{ fontSize: 9, color: "rgba(255,255,255,0.6)" }}>The Drew Mariani Show</div>
          </div>
        </div>
        <div style={{ width: 30, height: 30, borderRadius: "50%", background: "rgba(255,255,255,0.2)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", fontSize: 12 }}>⏸</div>
      </div>

      {/* Bottom nav */}
      <div style={{
        position: "absolute", bottom: 0, left: 0, right: 0, height: 68,
        background: "rgba(6,16,29,0.97)", backdropFilter: "blur(20px)",
        borderTop: "1px solid rgba(255,255,255,0.06)",
        display: "flex", justifyContent: "space-around", alignItems: "center", paddingBottom: 10, zIndex: 10,
      }}>
        {[
          { id: "home", label: "Home", onClick: () => { setActiveTab("home"); setView("menu"); }, icon: <svg width="21" height="21" viewBox="0 0 24 24" fill="none" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" /><polyline points="9 22 9 12 15 12 15 22" /></svg> },
          { id: "listen", label: "Listen", onClick: () => { setActiveTab("listen"); setView("main"); setMainSearch(""); }, icon: <svg width="21" height="21" viewBox="0 0 24 24" fill="none" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 18v-6a9 9 0 0 1 18 0v6" /><path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z" /></svg> },
          { id: "watch", label: "Watch", onClick: () => setActiveTab("watch"), icon: <svg width="21" height="21" viewBox="0 0 24 24" fill="none" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><polygon points="5 3 19 12 5 21 5 3" /></svg> },
          { id: "pray", label: "Pray", onClick: () => setActiveTab("pray"), icon: <svg width="21" height="21" viewBox="0 0 24 24" fill="none" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M17 3a2 2 0 0 1 2 2v2a2 2 0 0 1-2 2h-1v2.2a5 5 0 0 1-2.6 4.4L12 16.8l-1.4-1.2A5 5 0 0 1 8 11.2V9H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2" /><path d="M12 17v4" /><path d="M8 21h8" /></svg> },
        ].map((tab) => (
          <div key={tab.id} onClick={tab.onClick} style={{
            display: "flex", flexDirection: "column", alignItems: "center", gap: 3,
            cursor: "pointer", opacity: activeTab === tab.id ? 1 : 0.4, flex: 1,
          }}>
            <div style={{ stroke: activeTab === tab.id ? "#5b9bd5" : "#fff" }}>{tab.icon}</div>
            <span style={{ fontSize: 9, color: activeTab === tab.id ? "#5b9bd5" : "#fff", fontWeight: activeTab === tab.id ? 600 : 400 }}>{tab.label}</span>
          </div>
        ))}
        {/* LIVE button between Listen and Watch */}
      </div>
      {/* LIVE button overlay positioned in nav */}
      <div onClick={() => setActiveTab("live")} style={{
        position: "absolute", bottom: 18, left: "50%", transform: "translateX(-50%)",
        display: "flex", flexDirection: "column", alignItems: "center", gap: 3, cursor: "pointer", zIndex: 11,
      }}>
        <div style={{
          width: 38, height: 38, borderRadius: "50%",
          background: "linear-gradient(145deg, #d32f2f, #b71c1c)",
          display: "flex", alignItems: "center", justifyContent: "center",
          boxShadow: "0 2px 8px rgba(211,47,47,0.3)",
        }}>
          <StaticWaveform />
        </div>
        <span style={{ fontSize: 9, color: "#d32f2f", fontWeight: 700, letterSpacing: 0.3 }}>LIVE</span>
      </div>
    </div>
  );
}
