import { codeToHtml } from 'shiki'

export async function highlightCode(code: string, lang: string = 'r'): Promise<string> {
  return await codeToHtml(code, {
    lang,
    theme: 'github-light',
  })
}

