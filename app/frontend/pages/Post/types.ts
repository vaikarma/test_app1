export interface PostType {
  id: number
  title: string
  body: string
  published_at: string
}

export type PostFormType = Omit<PostType, 'id'>
