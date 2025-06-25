import { createTheme, lightThemePrimitives } from 'baseui'

const customPrimitives = {
  ...lightThemePrimitives,
  // Cores customizadas baseadas no design - Azul Ciano Vibrante
  accent: '#00D4FF', // Azul ciano vibrante
  accent50: '#F0FCFF',
  accent100: '#E0F9FF',
  accent200: '#BAF2FF',
  accent300: '#7EEBFF',
  accent400: '#00D4FF', // Cor principal
  accent500: '#00D4FF',
  accent600: '#00B8E6',
  accent700: '#0099CC',
  
  // Azul escuro/índigo para elementos secundários
  primary: '#1E3A8A', // Azul escuro/índigo
  primary50: '#EFF6FF',
  primary100: '#DBEAFE',
  primary200: '#BFDBFE',
  primary300: '#93C5FD',
  primary400: '#60A5FA',
  primary500: '#1E3A8A', // Azul escuro principal
  primary600: '#1E40AF',
  primary700: '#1D4ED8',
  
  // Cores de sucesso mantidas
  positive: '#27AE60',
  positive50: '#F0F9F4',
  positive100: '#D4F4E0',
  positive200: '#A8E6C1',
  positive300: '#7DD3A0',
  positive400: '#52C27F',
  positive500: '#27AE60',
  
  // Cores de background - Cinza escuro/carvão
  primaryB: '#FFFFFF',
  primaryA: '#F1F5F9', // Cinza muito claro com tom azulado
  backgroundDark: '#1E293B', // Cinza escuro/carvão
  
  // Cores de texto
  contentPrimary: '#1E293B', // Cinza escuro
  contentSecondary: '#64748B', // Cinza médio
  contentTertiary: '#94A3B8' // Cinza claro
}

export const futuroPDVTheme = createTheme(customPrimitives, {
  colors: {
    // Sobrescrever cores específicas do tema
    buttonSecondaryFill: customPrimitives.accent100,
    buttonSecondaryText: customPrimitives.accent,
    buttonSecondaryHover: customPrimitives.accent200,
    
    // Cores para cards
    backgroundSecondary: '#FFFFFF',
    borderOpaque: '#E2E8F0', // Cinza claro para bordas
    
    // Cores para o background principal
    backgroundPrimary: customPrimitives.backgroundDark, // Fundo escuro
    backgroundInverseSecondary: customPrimitives.accent,
    
    // Cores específicas do design
    inputFill: '#FFFFFF',
    inputBorder: '#CBD5E1', // Cinza claro para bordas dos inputs
    inputEnhancerFill: 'transparent',
  },
  
  // Configurações de tipografia
  typography: {
    HeadingXXLarge: {
      fontSize: '36px',
      fontWeight: 'bold',
      lineHeight: '44px'
    },
    HeadingXLarge: {
      fontSize: '32px',
      fontWeight: 'bold',
      lineHeight: '40px'
    },
    HeadingLarge: {
      fontSize: '28px',
      fontWeight: '600',
      lineHeight: '36px'
    },
    HeadingMedium: {
      fontSize: '24px',
      fontWeight: '600',
      lineHeight: '32px'
    }
  },
  
  // Configurações de espaçamento
  sizing: {
    scale0: '2px',
    scale100: '4px',
    scale200: '8px',
    scale300: '12px',
    scale400: '16px',
    scale500: '20px',
    scale600: '24px',
    scale700: '32px',
    scale800: '40px',
    scale900: '48px',
    scale1000: '64px'
  },
  
  // Configurações de borda
  borders: {
    radius100: '2px',
    radius200: '4px',
    radius300: '8px',
    radius400: '12px'
  }
})