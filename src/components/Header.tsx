import { useStyletron } from 'baseui'
import { Button } from 'baseui/button'
import { HeadingLarge } from 'baseui/typography'
import { AppNavBar, setItemActive } from 'baseui/app-nav-bar'
import { ChevronDown, Menu } from 'baseui/icon'

export const Header = () => {
  const [css, theme] = useStyletron()
  
  return (
    <AppNavBar
      title="Futuro PDV"
      mainItems={[
        { label: 'Vendas', info: { id: 'vendas' } },
        { label: 'Produtos', info: { id: 'produtos' } },
        { label: 'Relatórios', info: { id: 'relatorios' } },
        { label: 'Configurações', info: { id: 'config' } }
      ]}
      userItems={[
        { label: 'Perfil', info: { id: 'perfil' } },
        { label: 'Sair', info: { id: 'sair' } }
      ]}
      username="Usuário"
      usernameSubtitle="Admin"
      userImgUrl=""
      onMainItemSelect={setItemActive}
      onUserItemSelect={setItemActive}
      overrides={{
        Root: {
          style: {
            backgroundColor: theme.colors.backgroundPrimary,
            borderBottomWidth: '1px',
            borderBottomStyle: 'solid',
            borderBottomColor: theme.colors.borderOpaque,
            zIndex: 1000
          }
        }
      }}
    />
  )
}