import React, { useState } from 'react'
import { useStyletron } from 'baseui'
import { Button } from 'baseui/button'
import { Input } from 'baseui/input'
import { FormControl } from 'baseui/form-control'
import { HeadingMedium, ParagraphSmall } from 'baseui/typography'
import { Block } from 'baseui/block'

const Login: React.FC = () => {
  const [css, theme] = useStyletron()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)

  const containerStyle = css({
    minHeight: '100vh',
    backgroundColor: theme.colors.backgroundPrimary,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    padding: theme.sizing.scale400,
    fontFamily: 'system-ui, -apple-system, sans-serif',
  })

  const cardStyle = css({
    width: '100%',
    maxWidth: '400px',
    backgroundColor: theme.colors.backgroundSecondary,
    borderRadius: theme.borders.radius400,
    boxShadow: '0 4px 32px rgba(0, 0, 0, 0.15)',
    overflow: 'hidden',
  })

  const headerSectionStyle = css({
    backgroundColor: '#F8FAFC',
    padding: `${theme.sizing.scale800} ${theme.sizing.scale600}`,
    textAlign: 'center',
    borderBottom: `1px solid ${theme.colors.borderOpaque}`,
  })

  const logoContainerStyle = css({
    marginBottom: theme.sizing.scale400,
  })

  const logoTextStyle = css({
    fontSize: '28px',
    fontWeight: 'bold',
    letterSpacing: '-0.02em',
    marginBottom: theme.sizing.scale200,
  })

  const logoFuturoStyle = css({
    color: '#1E3A8A', // Azul escuro/índigo
  })

  const logoFStyle = css({
    position: 'relative',
    display: 'inline-block',
  })

  const logoPDVStyle = css({
    color: '#00D4FF', // Azul ciano
  })

  const logoUnderlineStyle = css({
    height: '3px',
    background: 'linear-gradient(90deg, #A855F7 0%, #00D4FF 100%)',
    borderRadius: '2px',
    marginTop: theme.sizing.scale100,
  })

  const formSectionStyle = css({
    padding: theme.sizing.scale800,
  })

  const socialButtonsContainerStyle = css({
    display: 'flex',
    gap: theme.sizing.scale400,
    justifyContent: 'center',
    marginBottom: theme.sizing.scale600,
  })

  const socialButtonStyle = css({
    width: '48px',
    height: '48px',
    borderRadius: '50%',
    border: `1px solid ${theme.colors.borderOpaque}`,
    backgroundColor: '#FFFFFF',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    ':hover': {
      boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)',
      transform: 'translateY(-1px)',
    },
  })

  const inputContainerStyle = css({
    marginBottom: theme.sizing.scale500,
  })

  const inputLabelStyle = css({
    fontSize: '14px',
    fontWeight: '500',
    color: theme.colors.contentPrimary,
    marginBottom: theme.sizing.scale200,
    display: 'block',
  })

  const linksContainerStyle = css({
    textAlign: 'center',
    marginTop: theme.sizing.scale600,
  })

  const linkStyle = css({
    fontSize: '14px',
    marginBottom: theme.sizing.scale300,
  })

  const linkTextStyle = css({
    color: theme.colors.contentSecondary,
  })

  const linkActionStyle = css({
    color: '#00D4FF',
    textDecoration: 'none',
    fontWeight: '500',
    ':hover': {
      textDecoration: 'underline',
    },
  })

  return (
    <div className={containerStyle}>
      <div className={cardStyle}>
        {/* Header Section with Logo */}
        <div className={headerSectionStyle}>
          <div className={logoContainerStyle}>
            <div className={logoTextStyle}>
              <span className={logoFuturoStyle}>
                <span className={logoFStyle}>F</span>uturo
              </span>{' '}
              <span className={logoPDVStyle}>PDV</span>
            </div>
            <div className={logoUnderlineStyle}></div>
          </div>
        </div>

        {/* Form Section */}
        <div className={formSectionStyle}>
          <HeadingMedium 
            marginBottom="scale600" 
            $style={{ textAlign: 'center', color: theme.colors.contentPrimary, fontSize: '24px', fontWeight: '600' }}
          >
            Login
          </HeadingMedium>

          {/* Email Field */}
          <div className={inputContainerStyle}>
            <label className={inputLabelStyle}>E-mail</label>
            <Input
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Login de Cadastro"
              type="email"
              endEnhancer={
                <span style={{ color: theme.colors.contentSecondary, fontSize: '16px' }}>@</span>
              }
              overrides={{
                Root: {
                  style: {
                    borderRadius: theme.borders.radius300,
                  }
                },
                Input: {
                  style: {
                    backgroundColor: theme.colors.inputFill,
                    borderColor: theme.colors.inputBorder,
                    ':focus': {
                      borderColor: theme.colors.accent,
                    },
                  }
                },
                InputContainer: {
                  style: {
                    backgroundColor: theme.colors.inputFill,
                  }
                }
              }}
            />
          </div>

          {/* Password Field */}
          <div className={inputContainerStyle}>
            <label className={inputLabelStyle}>Senha</label>
            <Input
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Senha"
              type={showPassword ? 'text' : 'password'}
              endEnhancer={
                <Button
                  kind="tertiary"
                  size="mini"
                  onClick={() => setShowPassword(!showPassword)}
                  overrides={{
                    BaseButton: {
                      style: {
                        padding: '0',
                        minWidth: 'auto',
                        backgroundColor: 'transparent',
                        color: theme.colors.contentSecondary,
                      }
                    }
                  }}
                >
                  {showPassword ? '👁️' : '👁️‍🗨️'}
                </Button>
              }
              overrides={{
                Root: {
                  style: {
                    borderRadius: theme.borders.radius300,
                  }
                },
                Input: {
                  style: {
                    backgroundColor: theme.colors.inputFill,
                    borderColor: theme.colors.inputBorder,
                    ':focus': {
                      borderColor: theme.colors.accent,
                    },
                  }
                },
                InputContainer: {
                  style: {
                    backgroundColor: theme.colors.inputFill,
                  }
                }
              }}
            />
          </div>

          {/* Login Button */}
          <Block marginBottom="scale600">
            <Button
              size="large"
              overrides={{
                BaseButton: { 
                  style: { 
                    width: '100%',
                    backgroundColor: '#00D4FF',
                    borderRadius: theme.borders.radius300,
                    fontSize: '16px',
                    fontWeight: '600',
                    ':hover': {
                      backgroundColor: '#00B8E6',
                    }
                  } 
                }
              }}
            >
              Entrar
            </Button>
          </Block>

          {/* Social Login Buttons */}
          <div className={socialButtonsContainerStyle}>
            <div className={socialButtonStyle}>
              <svg width="20" height="20" viewBox="0 0 24 24">
                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
              </svg>
            </div>
            <div className={socialButtonStyle}>
              <svg width="20" height="20" viewBox="0 0 24 24">
                <path fill="#000000" d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
              </svg>
            </div>
          </div>

          {/* Navigation Links */}
          <div className={linksContainerStyle}>
            <div className={linkStyle}>
              <span className={linkTextStyle}>Faça parte do Futuro </span>
              <a href="#" className={linkActionStyle}>Cadastre-se</a>
            </div>
            <div className={linkStyle}>
              <span className={linkTextStyle}>Esqueci minha </span>
              <a href="#" className={linkActionStyle}>Senha</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Login