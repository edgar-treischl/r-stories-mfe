export type StoryVariant = {
  id: string
  title: string
  description?: string
  code: string
  image: string
}

export type Story = {
  id: string
  title: string
  category: string
  description?: string
  variants: StoryVariant[]
}
