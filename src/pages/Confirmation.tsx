import React from 'react'
import { Button } from 'baseui/button'
import { Card, StyledBody } from 'baseui/card'
import { HeadingXLarge, ParagraphLarge } from 'baseui/typography'
import { useStyletron } from 'baseui'
import { Block } from 'baseui/block'

const Confirmation: React.FC = () => {
  const [css, $theme] = useStyletron()

  const handleOkClick = () => {
    console.log('Usuário confirmou o cadastro')
  }

  return (
    <Block
      backgroundColor={$theme.colors.backgroundPrimary}
      minHeight="100vh"
      display="flex"
      alignItems="center"
      justifyContent="center"
      padding={$theme.sizing.scale700}
    >
      <Card
        overrides={{
          Root: {
            style: {
              width: '100%',
              maxWidth: '400px',
              boxShadow: $theme.lighting.shadow400,
              textAlign: 'center'
            }
          }
        }}
      >
        <StyledBody>
          <HeadingXLarge
            marginBottom={$theme.sizing.scale700}
            color={$theme.colors.contentPrimary}
            textAlign="center"
          >
            Quase lá!
          </HeadingXLarge>

          <Block
            marginBottom={$theme.sizing.scale700}
            display="flex"
            justifyContent="center"
            alignItems="center"
          >
            <Block
              width="80px"
              height="80px"
              backgroundColor={$theme.colors.accent100}
              borderRadius="50%"
              display="flex"
              alignItems="center"
              justifyContent="center"
              marginBottom={$theme.sizing.scale600}
            >
              <span
                className={css({
                  fontSize: '40px',
                  color: $theme.colors.accent
                })}
              >
                ✅
              </span>
            </Block>
          </Block>

          <ParagraphLarge
            marginBottom={$theme.sizing.scale800}
            color={$theme.colors.contentSecondary}
            textAlign="center"
            lineHeight="1.6"
          >
            Seu cadastro foi enviado! Nossa equipe irá revisar seus documentos e você será notificado assim que seu perfil for aprovado.
          </ParagraphLarge>

          <Button
            onClick={handleOkClick}
            size="large"
            overrides={{
              BaseButton: { 
                style: { 
                  width: '100%',
                  backgroundColor: $theme.colors.accent,
                  ':hover': {
                    backgroundColor: $theme.colors.accent600
                  }
                } 
              }
            }}
          >
            Ok, entendi!
          </Button>
        </StyledBody>
      </Card>
    </Block>
  )
}

export default Confirmation