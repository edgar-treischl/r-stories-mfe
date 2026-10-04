import type { Story, StoryVariant } from "./types"

interface MarkdownFrontmatter {
  id: string
  title: string
  category: string
  description?: string
}

/**
 * Splits markdown body text on H2 headers (## ), respecting code blocks.
 * Code blocks (between ``` markers) are not split.
 */
function splitOnH2(text: string): string[] {
  const sections: string[] = []
  let currentSection = ""
  let inCodeBlock = false
  const lines = text.split("\n")

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]

    // Toggle code block state
    if (line.startsWith("```")) {
      inCodeBlock = !inCodeBlock
    }

    // Check for H2 header outside code blocks
    if (!inCodeBlock && line.startsWith("## ") && currentSection.trim()) {
      sections.push(currentSection)
      currentSection = line
    } else {
      if (currentSection) currentSection += "\n"
      currentSection += line
    }
  }

  if (currentSection.trim()) {
    sections.push(currentSection)
  }

  return sections
}

/**
 * Parses a markdown story file with frontmatter and variant sections.
 * 
 * Format:
 * ```
 * ---
 * id: plots/scatter
 * title: Scatter Plot
 * category: Plots
 * description: Optional description
 * ---
 * 
 * ## Basic
 * 
 * Optional variant description here.
 * 
 * ```r
 * library(ggplot2)
 * ggplot(mtcars, aes(wt, mpg)) +
 *   geom_point()
 * ```
 * 
 * ![](./scatter-basic.png)
 * 
 * ## Colored
 * 
 * ...
 * ```
 */
export function parseMarkdownStory(
  content: string,
  imagePath: (imageName: string) => string,
  codePath?: (fileName: string) => string,
): Story | null {
  // Extract frontmatter
  const frontmatterMatch = content.match(
    /^---\n([\s\S]*?)\n---\n([\s\S]*)$/,
  )

  if (!frontmatterMatch) {
    console.warn("Story markdown missing frontmatter")
    return null
  }

  const frontmatterText = frontmatterMatch[1]
  const bodyText = frontmatterMatch[2]

  // Parse YAML-like frontmatter
  const frontmatter = parseFrontmatter(frontmatterText)

  if (
    !frontmatter.id ||
    !frontmatter.title ||
    !frontmatter.category
  ) {
    console.warn(
      "Story frontmatter missing required fields: id, title, category",
    )
    return null
  }

  // Extract variants from h2 sections (respecting code blocks)
  const variants: StoryVariant[] = []
  const variantSections = splitOnH2(bodyText)

  for (const section of variantSections) {
    const variant = parseVariantSection(section, imagePath, codePath)
    if (variant) {
      variants.push(variant)
    }
  }

  if (variants.length === 0) {
    console.warn(
      `Story "${frontmatter.id}" has no variants with code blocks`,
    )
    return null
  }

  return {
    id: frontmatter.id,
    title: frontmatter.title,
    category: frontmatter.category,
    description: frontmatter.description,
    variants,
  }
}

function parseFrontmatter(text: string): Partial<MarkdownFrontmatter> {
  const result: Partial<MarkdownFrontmatter> = {}

  const lines = text.split("\n")
  for (const line of lines) {
    const match = line.match(/^(\w+):\s*(.+)$/)
    if (match) {
      const [, key, value] = match
      result[key as keyof MarkdownFrontmatter] = value.trim()
    }
  }

  return result
}

function parseVariantSection(
  section: string,
  imagePath: (imageName: string) => string,
  codePath?: (fileName: string) => string,
): StoryVariant | null {
  // Extract title (first line, removing ## if present)
  const lines = section.split("\n")
  const titleLine = lines[0].replace(/^#+\s*/, "")

  if (!titleLine) {
    return null
  }

  // Extract description (lines before code block)
  const descriptionLines: string[] = []
  let codeBlockStart = -1

  for (let i = 1; i < lines.length; i++) {
    if (lines[i].startsWith("```")) {
      codeBlockStart = i
      break
    }
    descriptionLines.push(lines[i])
  }

  if (codeBlockStart === -1) {
    return null // No code block found
  }

  // Remove trailing empty lines from description and trim
  while (descriptionLines.length > 0 && !descriptionLines[descriptionLines.length - 1].trim()) {
    descriptionLines.pop()
  }

  // Extract code block
  let codeBlockEnd = -1

  for (let i = codeBlockStart + 1; i < lines.length; i++) {
    if (lines[i].startsWith("```")) {
      codeBlockEnd = i
      break
    }
  }

  if (codeBlockEnd === -1) {
    return null // Unclosed code block
  }

  const codeLines = lines.slice(codeBlockStart + 1, codeBlockEnd)
  let code = codeLines.join("\n").trim()

  // Check if the code is a file reference like !r(filename.R)
  const fileRefMatch = code.match(/^!r\((.+?)\)$/)
  if (fileRefMatch && codePath) {
    const fileName = fileRefMatch[1]
    code = codePath(fileName)
  }

  // Extract image reference
  let imageUrl = ""
  for (let i = codeBlockEnd + 1; i < lines.length; i++) {
    const imgMatch = lines[i].match(/!\[\]\((.+?)\)/)
    if (imgMatch) {
      const imageName = imgMatch[1].replace(/^\.\//, "") // Strip leading ./
      imageUrl = imagePath(imageName)
      break
    }
  }

  if (!imageUrl) {
    return null // No image found
  }

  return {
    id: titleLine
      .toLowerCase()
      .replace(/[^\w\s-]/g, "") // Remove special characters
      .replace(/\s+/g, "-"), // Replace spaces with hyphens
    title: titleLine,
    description: descriptionLines.length > 0 
      ? descriptionLines.join("\n").trim()
      : undefined,
    code,
    image: imageUrl,
  }
}
