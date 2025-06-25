import { Drawer } from 'baseui/drawer'
import { Button } from 'baseui/button'
import { HeadingMedium, LabelMedium, ParagraphSmall } from 'baseui/typography'
import { useStyletron } from 'baseui'
import { Delete, Minus, Plus } from 'baseui/icon'
import { Divider } from 'baseui/divider'

interface CartItem {
  id: string
  name: string
  price: number
  quantity: number
}

interface CartSidebarProps {
  isOpen: boolean
  onClose: () => void
  items: CartItem[]
  onUpdateQuantity: (id: string, quantity: number) => void
  onRemoveItem: (id: string) => void
  onCheckout: () => void
}

export const CartSidebar = ({
  isOpen,
  onClose,
  items,
  onUpdateQuantity,
  onRemoveItem,
  onCheckout
}: CartSidebarProps) => {
  const [css, theme] = useStyletron()
  
  const total = items.reduce((sum, item) => sum + (item.price * item.quantity), 0)
  
  return (
    <Drawer
      isOpen={isOpen}
      onClose={onClose}
      anchor="right"
      size="400px"
      overrides={{
        DrawerContainer: {
          style: {
            backgroundColor: theme.colors.backgroundPrimary
          }
        }
      }}
    >
      <div className={css({
        padding: theme.sizing.scale600,
        height: '100%',
        display: 'flex',
        flexDirection: 'column'
      })}>
        <HeadingMedium marginBottom="scale600">
          Carrinho de Compras
        </HeadingMedium>
        
        <div className={css({ flex: 1, overflowY: 'auto' })}>
          {items.length === 0 ? (
            <ParagraphSmall color="contentSecondary">
              Carrinho vazio
            </ParagraphSmall>
          ) : (
            items.map((item) => (
              <div key={item.id} className={css({
                marginBottom: theme.sizing.scale600,
                padding: theme.sizing.scale400,
                border: `1px solid ${theme.colors.borderOpaque}`,
                borderRadius: theme.borders.radius300
              })}>
                <div className={css({
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'flex-start',
                  marginBottom: theme.sizing.scale300
                })}>
                  <LabelMedium>{item.name}</LabelMedium>
                  <Button
                    kind="tertiary"
                    size="mini"
                    onClick={() => onRemoveItem(item.id)}
                    overrides={{
                      BaseButton: { style: { padding: '4px' } }
                    }}
                  >
                    <Delete size={16} />
                  </Button>
                </div>
                
                <div className={css({
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center'
                })}>
                  <div className={css({ display: 'flex', alignItems: 'center', gap: '8px' })}>
                    <Button
                      kind="secondary"
                      size="mini"
                      onClick={() => onUpdateQuantity(item.id, Math.max(0, item.quantity - 1))}
                      disabled={item.quantity <= 1}
                    >
                      <Minus size={12} />
                    </Button>
                    <ParagraphSmall>{item.quantity}</ParagraphSmall>
                    <Button
                      kind="secondary"
                      size="mini"
                      onClick={() => onUpdateQuantity(item.id, item.quantity + 1)}
                    >
                      <Plus size={12} />
                    </Button>
                  </div>
                  
                  <LabelMedium>
                    R$ {(item.price * item.quantity).toFixed(2)}
                  </LabelMedium>
                </div>
              </div>
            ))
          )}
        </div>
        
        {items.length > 0 && (
          <>
            <Divider />
            <div className={css({
              padding: `${theme.sizing.scale400} 0`,
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center'
            })}>
              <HeadingMedium>Total:</HeadingMedium>
              <HeadingMedium color="contentPositive">
                R$ {total.toFixed(2)}
              </HeadingMedium>
            </div>
            
            <Button
              onClick={onCheckout}
              size="large"
              overrides={{
                BaseButton: { 
                  style: { 
                    width: '100%',
                    backgroundColor: theme.colors.positive,
                    ':hover': {
                      backgroundColor: theme.colors.positive600
                    }
                  } 
                }
              }}
            >
              Finalizar Compra
            </Button>
          </>
        )}
      </div>
    </Drawer>
  )
}