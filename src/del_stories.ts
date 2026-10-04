export type Story = {
  id: string
  title: string
  category: string
  description: string
  code: string
  image: string
}

export const stories: Story[] = [
  {
    id: "scatter-plot",
    title: "Scatter Plot",
    category: "Plots",
    description: "A basic scatter plot using ggplot2.",
    code: `library(ggplot2)

ggplot(mtcars, aes(wt, mpg)) +
  geom_point()`,
    image: "/plots/scatter.png",
  },
]
