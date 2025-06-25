import { Card, StyledBody, StyledAction } from 'baseui/card'
import { Button } from 'baseui/button'
import { HeadingMedium, LabelMedium, ParagraphSmall } from 'baseui/typography'
import { useStyletron } from 'baseui'
import { Plus } from 'baseui/icon'

interface ProductCardProps {
  id: string
  name: string
  price: number
  description?: string
  image?: string
  onAddToCart: (productId: string) => void
}

export const ProductCard = ({ 
  id, 
  name, 
  price, 
  description, 
  image, 
  onAddToCart 
}: ProductCardProps) => {
  const [css, theme] = useStyletron()
  
  return (
    <Card
      overrides={{
        Root: {
          style: {
            width: '280px',
            marginBottom: theme.sizing.scale600,
            transition: 'transform 0.2s ease, box-shadow 0.2s ease',
            ':hover': {
              transform: 'translateY(-2px)',
              boxShadow: theme.lighting.shadow600
            }
          }
        }
      }}
    >
      {image && (
        <div className={css({
          width: '100%',
          height: '160px',
          backgroundImage: `url(${image})`,
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          borderTopLeftRadius: theme.borders.radius300,
          borderTopRightRadius: theme.borders.radius300
        })} />
      )}
      
      <StyledBody>
        <HeadingMedium marginBottom="scale300">
          {name}
        </HeadingMedium>
        
        {description && (
          <ParagraphSmall 
            marginBottom="scale400" 
            color="contentSecondary"
          >
            {description}
          </ParagraphSmall>
        )}
        
        <LabelMedium 
          color="contentPrimary"
          overrides={{
            Block: {
              style: {
                fontSize: theme.typography.LabelLarge.fontSize,
                fontWeight: 'bold',
                color: theme.colors.contentPositive
              }
            }
          }}
        >
          R$ {price.toFixed(2)}
        </LabelMedium>
      </StyledBody>
      
      <StyledAction>
        <Button
          onClick={() => onAddToCart(id)}
          startEnhancer={() => <Plus size={20} />}
          overrides={{
            BaseButton: { 
              style: { 
                width: '100%',
                backgroundColor: theme.colors.accent,
                ':hover': {
                  backgroundColor: theme.colors.accent600
                }
              } 
            }
          }}
        >
          Adicionar ao Carrinho
        </Button>
      </StyledAction>
    </Card>
  )
}