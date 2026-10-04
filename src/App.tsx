import { useEffect, useState } from "react"
import { useLocation, useNavigate, BrowserRouter } from "react-router-dom"
import { stories } from "./stories"
import { highlightCode } from "./highlight"
import { parseInlineMarkdown } from "./utils/parseMarkdown"
import { LandingPage } from "./components/LandingPage"
import ScrollToTop from "./components/ScrollToTop"

function AppContent() {
  const [highlightedCode, setHighlightedCode] = useState("")
  const location = useLocation()
  const navigate = useNavigate()

  const path = location.pathname.replace(/^\/|\/$/g, "")
  const isLandingPage = !path

  const story =
    stories.find(
      (item) =>
        path === item.id ||
        path.startsWith(`${item.id}/`),
    ) ?? null

  const variantId = story
    ? path.slice(story.id.length + 1)
    : ""

  const variant =
    story?.variants.find(
      (item) => item.id === variantId,
    ) ?? story?.variants[0] ?? null

  useEffect(() => {
    if (isLandingPage) return

    if (!story || !variant) {
      const firstStory = stories[0]

      if (firstStory) {
        navigate(
          `/${firstStory.id}/${firstStory.variants[0].id}`,
          { replace: true },
        )
      }

      return
    }

    const expectedPath = `/${story.id}/${variant.id}`

    if (location.pathname !== expectedPath) {
      navigate(expectedPath, { replace: true })
    }
  }, [story, variant, location.pathname, navigate, isLandingPage])

  useEffect(() => {
    if (!variant) return

    highlightCode(variant.code, 'r').then(setHighlightedCode)
  }, [variant])

  if (isLandingPage) {
    return <LandingPage />
  }

  if (!story || !variant) {
    return null
  }

  const categories = [
    ...new Set(stories.map((item) => item.category)),
  ]

  function selectStory(id: string) {
    const nextStory = stories.find(
      (item) => item.id === id,
    )

    if (!nextStory || nextStory.variants.length === 0) {
      return
    }

    navigate(
      `/${nextStory.id}/${nextStory.variants[0].id}`,
    )
  }

  function selectVariant(id: string) {
    if (!story) return

    navigate(`/${story.id}/${id}`)
  }

  function copyCode() {
    if (!variant) return

    navigator.clipboard.writeText(variant.code)
  }

  return (
    <div className="app">
      <aside className="sidebar">
        <button
          className="brand"
          onClick={() => navigate("/")}
        >
          <div className="brand-mark">R</div>

          <div>
            <strong>R Stories</strong>
          </div>
        </button>

        <nav>
          {categories.map((category) => (
            <div
              key={category}
              className="category"
            >
              <div className="category-title">
                {category}
              </div>

              {stories
                .filter(
                  (item) =>
                    item.category === category,
                )
                .map((item) => (
                  <button
                    key={item.id}
                    className={
                      item.id === story.id
                        ? "story active"
                        : "story"
                    }
                    onClick={() =>
                      selectStory(item.id)
                    }
                  >
                    {item.title}
                  </button>
                ))}
            </div>
          ))}
        </nav>
      </aside>

      <main className="content">
        <header>
          <div className="breadcrumb">
            {story.category} / {story.title}
          </div>

          <h1>{story.title}</h1>

          {story.description && (
            <div dangerouslySetInnerHTML={{ __html: parseInlineMarkdown(story.description) }} />
          )}
        </header>

        <div className="variants">
          {story.variants.map((item) => (
            <button
              key={item.id}
              className={
                item.id === variant.id
                  ? "variant active"
                  : "variant"
              }
              onClick={() =>
                selectVariant(item.id)
              }
            >
              {item.title}
            </button>
          ))}
        </div>

        {variant.description && (
          <div className="variant-description" dangerouslySetInnerHTML={{ __html: parseInlineMarkdown(variant.description) }} />
        )}


        <section className="preview">
          <img
            src={variant.image}
            alt={variant.title}
            className={variant.image.endsWith('.svg') ? 'preview-svg' : 'preview-raster'}
          />
        </section>

        <section className="code-section">
          <div className="section-header">
            <h2>Code Snippet</h2>
            <button onClick={copyCode}>
              Copy
            </button>
          </div>

          <div
            className="shiki"
            dangerouslySetInnerHTML={{ __html: highlightedCode }}
          />
        </section>
      </main>
    </div>
  )
}

function App() {
  return (
    <BrowserRouter basename="/r-stories-mfe/">
      <ScrollToTop />
      <AppContent />
    </BrowserRouter>
  )
}

export default App
