import React, { useState } from 'react'
import { Button } from 'baseui/button'
import { Card, StyledBody } from 'baseui/card'
import { HeadingXLarge, ParagraphMedium } from 'baseui/typography'
import { FormControl } from 'baseui/form-control'
import { Input } from 'baseui/input'
import { Checkbox } from 'baseui/checkbox'
import { useStyletron } from 'baseui'
import { Block } from 'baseui/block'

const CreateAccount: React.FC = () => {
  const [css, $theme] = useStyletron()
  const [formData, setFormData] = useState({
    fullName: '',
    email: '',
    password: '',
    acceptTerms: false
  })

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }))
  }

  const handleSubmit = () => {
    console.log('Criar conta:', formData)
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
              boxShadow: $theme.lighting.shadow400
            }
          }
        }}
      >
        <StyledBody>
          <HeadingXLarge
            marginBottom={$theme.sizing.scale800}
            color={$theme.colors.contentPrimary}
            textAlign="center"
          >
            Crie sua Conta
          </HeadingXLarge>

          <FormControl label="Nome Completo">
            <Input
              value={formData.fullName}
              onChange={(e) => handleInputChange('fullName', e.currentTarget.value)}
              placeholder="Digite seu nome completo"
              size="large"
            />
          </FormControl>

          <FormControl label="E-mail">
            <Input
              value={formData.email}
              onChange={(e) => handleInputChange('email', e.currentTarget.value)}
              placeholder="Digite seu e-mail"
              type="email"
              size="large"
            />
          </FormControl>

          <FormControl label="Criar Senha">
            <Input
              value={formData.password}
              onChange={(e) => handleInputChange('password', e.currentTarget.value)}
              placeholder="Digite sua senha"
              type="password"
              size="large"
            />
          </FormControl>

          <Block marginTop={$theme.sizing.scale600} marginBottom={$theme.sizing.scale600}>
            <Button
              kind="secondary"
              size="large"
              overrides={{
                BaseButton: { style: { width: '100%', marginBottom: $theme.sizing.scale300 } }
              }}
            >
              🔍 Continuar com Google
            </Button>

            <Button
              kind="secondary"
              size="large"
              overrides={{
                BaseButton: { style: { width: '100%' } }
              }}
            >
              🍎 Continuar com Apple
            </Button>
          </Block>

          <Block marginTop={$theme.sizing.scale600} marginBottom={$theme.sizing.scale600}>
            <Checkbox
              checked={formData.acceptTerms}
              onChange={(e) => setFormData(prev => ({ ...prev, acceptTerms: e.currentTarget.checked }))}
            >
              <ParagraphMedium color={$theme.colors.contentSecondary}>
                Li e aceito os Termos de Serviço e a Política de Privacidade.
              </ParagraphMedium>
            </Checkbox>
          </Block>

          <Button
            onClick={handleSubmit}
            size="large"
            disabled={!formData.acceptTerms}
            overrides={{
              BaseButton: { style: { width: '100%' } }
            }}
          >
            Criar Conta
          </Button>
        </StyledBody>
      </Card>
    </Block>
  )
}

export default CreateAccount