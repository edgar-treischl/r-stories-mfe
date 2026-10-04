# Dash-Shell Template

Create a react-ts project with:

```
yarn create vite app3 --template react-ts
```

Install via:

```
yarn install
```

Update `vite.conig.ts` and use GitHub Actions to deploy. A corresponding workflow is included in the repository.


## CSS

 Key Improvements for MFE Architecture:

  1. Scoped CSS Custom Properties

   - All variables now prefixed with --mfe-template-* to avoid conflicts with host app 
  or other MFEs
   - Added semantic tokens: --mfe-template-heading, --mfe-template-surface, 
  --mfe-template-elevated

  2. BEM-Style Class Names

   - Changed from generic IDs (#center, #docs) to scoped classes (.mfe-template__center,
   .mfe-template__docs)
   - Follows the pattern: .mfe-template (block) → .mfe-template__element (element)
   - Prevents CSS collisions when multiple MFEs are on the same page

  3. Component-Scoped Styles

   - Root container .mfe-template wraps everything
   - All child elements inherit scoped tokens
   - Uses * { box-sizing: border-box } within scope only

  4. Modern CSS Improvements

   - clamp() for fluid typography instead of fixed breakpoints
   - Improved transition consistency (0.15s ease everywhere)
   - Better focus states with ring-style outlines
   - Enhanced button states (hover, active, disabled)