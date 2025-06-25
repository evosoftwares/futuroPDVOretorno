export interface Product {
  id: string
  name: string
  price: number
  description?: string
  image?: string
  category?: string
  stock?: number
}

export interface CartItem {
  id: string
  name: string
  price: number
  quantity: number
}

export interface Sale {
  id: string
  items: CartItem[]
  total: number
  date: Date
  paymentMethod: 'cash' | 'card' | 'pix'
  customerName?: string
}