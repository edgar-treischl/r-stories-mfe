/**
 * Simple markdown to HTML converter for inline markdown.
 * Supports: bold (**text**), italic (*text*), code (`text`), links ([text](url)), and paragraph breaks
 */
export function parseInlineMarkdown(text: string): string {
  if (!text) return ""

  // Split by double newlines to handle paragraph breaks
  const paragraphs = text.split(/\n\n+/).map((para) => {
    let html = para
      // Escape HTML special characters first
      .replace(/&(?!#?\w+;)/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")

    // Bold: **text** -> <strong>text</strong>
    html = html.replace(/\*\*(.+?)\*\*/g, "<strong>$1</strong>")

    // Italic: *text* -> <em>text</em>
    html = html.replace(/\*(.+?)\*/g, "<em>$1</em>")

    // Code: `text` -> <code>text</code>
    html = html.replace(/`([^`]+)`/g, "<code>$1</code>")

    // Links: [text](url) -> <a href="url">text</a>
    html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>')

    return html
  })

  // Join paragraphs with closing and opening tags
  return paragraphs.filter((p) => p.trim()).length > 1
    ? `<p>${paragraphs.filter((p) => p.trim()).join("</p><p>")}</p>`
    : paragraphs[0] || ""
}
