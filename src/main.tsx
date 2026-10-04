import { StrictMode } from "react"
import { createRoot } from "react-dom/client"
import {
  BrowserRouter,
  Routes,
  Route,
} from "react-router-dom"

import "./index.css"
import App from "./App"
import ScrollToTop from "./components/ScrollToTop"

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <BrowserRouter basename="/r-stories-mfe/">
      <ScrollToTop />
      <Routes>
        <Route path="*" element={<App />} />
      </Routes>
    </BrowserRouter>
  </StrictMode>,
)
