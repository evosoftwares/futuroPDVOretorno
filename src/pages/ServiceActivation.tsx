import React, { useState } from 'react'
import { Button } from 'baseui/button'
import { Card, StyledBody } from 'baseui/card'
import { HeadingXLarge, HeadingMedium, ParagraphMedium, ParagraphSmall } from 'baseui/typography'
import { FileUploader } from 'baseui/file-uploader'
import { useStyletron } from 'baseui'
import { Block } from 'baseui/block'
import { Badge } from 'baseui/badge'

interface ServiceState {
  active: boolean
  documents: {
    cnh?: File[]
    crlv?: File[]
    rg?: File[]
    residencia?: File[]
  }
  status: 'pending' | 'verified' | 'rejected'
}

const ServiceActivation: React.FC = () => {
  const [css, $theme] = useStyletron()
  const [transportService, setTransportService] = useState<ServiceState>({
    active: false,
    documents: {},
    status: 'pending'
  })
  const [freelancerService, setFreelancerService] = useState<ServiceState>({
    active: false,
    documents: {},
    status: 'pending'
  })

  const handleTransportActivation = () => {
    setTransportService(prev => ({ ...prev, active: !prev.active }))
  }

  const handleFreelancerActivation = () => {
    setFreelancerService(prev => ({ ...prev, active: !prev.active }))
  }

  const handleFileUpload = (service: 'transport' | 'freelancer', docType: string, files: File[]) => {
    if (service === 'transport') {
      setTransportService(prev => ({
        ...prev,
        documents: { ...prev.documents, [docType]: files }
      }))
    } else {
      setFreelancerService(prev => ({
        ...prev,
        documents: { ...prev.documents, [docType]: files }
      }))
    }
  }

  const getStatusBadge = (status: string) => {
    const statusConfig = {
      pending: { content: 'Verificação Pendente', color: 'warning' as const },
      verified: { content: 'Verificado', color: 'positive' as const },
      rejected: { content: 'Rejeitado', color: 'negative' as const }
    }
    
    const config = statusConfig[status as keyof typeof statusConfig]
    return (
      <Badge content={config.content} color={config.color} />
    )
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
              maxWidth: '500px',
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
            Seu Perfil de Parceiro
          </HeadingXLarge>

          {/* Seção 1: Transporte de Passageiros */}
          <Card
            overrides={{
              Root: {
                style: {
                  marginBottom: $theme.sizing.scale700,
                  backgroundColor: $theme.colors.backgroundSecondary,
                  border: `1px solid ${$theme.colors.borderOpaque}`
                }
              }
            }}
          >
            <StyledBody>
              <Block display="flex" justifyContent="space-between" alignItems="center" marginBottom={$theme.sizing.scale500}>
                <HeadingMedium color={$theme.colors.contentPrimary}>
                  Transporte de Passageiros
                </HeadingMedium>
                <Button
                  onClick={handleTransportActivation}
                  kind={transportService.active ? 'secondary' : 'primary'}
                  size="compact"
                >
                  {transportService.active ? 'Desativar' : 'Ativar'}
                </Button>
              </Block>

              {transportService.active && (
                <Block>
                  <Block marginBottom={$theme.sizing.scale600}>
                    <ParagraphMedium marginBottom={$theme.sizing.scale300}>
                      Foto da CNH (frente e verso)
                    </ParagraphMedium>
                    <FileUploader
                      onDrop={(acceptedFiles) => handleFileUpload('transport', 'cnh', acceptedFiles)}
                      accept={['image/*']}
                      multiple
                      maxFiles={2}
                      overrides={{
                        ContentMessage: {
                          style: {
                            color: $theme.colors.contentSecondary
                          }
                        }
                      }}
                    />
                  </Block>

                  <Block marginBottom={$theme.sizing.scale600}>
                    <ParagraphMedium marginBottom={$theme.sizing.scale300}>
                      Documento do Veículo (CRLV)
                    </ParagraphMedium>
                    <FileUploader
                      onDrop={(acceptedFiles) => handleFileUpload('transport', 'crlv', acceptedFiles)}
                      accept={['image/*']}
                      overrides={{
                        ContentMessage: {
                          style: {
                            color: $theme.colors.contentSecondary
                          }
                        }
                      }}
                    />
                  </Block>

                  <Block display="flex" alignItems="center">
                    <ParagraphSmall marginRight={$theme.sizing.scale300}>
                      Status:
                    </ParagraphSmall>
                    {getStatusBadge(transportService.status)}
                  </Block>
                </Block>
              )}
            </StyledBody>
          </Card>

          {/* Seção 2: Serviços de Freelancer */}
          <Card
            overrides={{
              Root: {
                style: {
                  marginBottom: $theme.sizing.scale700,
                  backgroundColor: $theme.colors.backgroundSecondary,
                  border: `1px solid ${$theme.colors.borderOpaque}`
                }
              }
            }}
          >
            <StyledBody>
              <Block display="flex" justifyContent="space-between" alignItems="center" marginBottom={$theme.sizing.scale500}>
                <HeadingMedium color={$theme.colors.contentPrimary}>
                  Serviços de Freelancer
                </HeadingMedium>
                <Button
                  onClick={handleFreelancerActivation}
                  kind={freelancerService.active ? 'secondary' : 'primary'}
                  size="compact"
                >
                  {freelancerService.active ? 'Desativar' : 'Ativar'}
                </Button>
              </Block>

              {freelancerService.active && (
                <Block>
                  <Block marginBottom={$theme.sizing.scale600}>
                    <ParagraphMedium marginBottom={$theme.sizing.scale300}>
                      Foto do RG ou CNH (frente e verso)
                    </ParagraphMedium>
                    <FileUploader
                      onDrop={(acceptedFiles) => handleFileUpload('freelancer', 'rg', acceptedFiles)}
                      accept={['image/*']}
                      multiple
                      maxFiles={2}
                      overrides={{
                        ContentMessage: {
                          style: {
                            color: $theme.colors.contentSecondary
                          }
                        }
                      }}
                    />
                  </Block>

                  <Block marginBottom={$theme.sizing.scale600}>
                    <ParagraphMedium marginBottom={$theme.sizing.scale300}>
                      Comprovante de Residência
                    </ParagraphMedium>
                    <FileUploader
                      onDrop={(acceptedFiles) => handleFileUpload('freelancer', 'residencia', acceptedFiles)}
                      accept={['image/*', 'application/pdf']}
                      overrides={{
                        ContentMessage: {
                          style: {
                            color: $theme.colors.contentSecondary
                          }
                        }
                      }}
                    />
                  </Block>

                  <Block display="flex" alignItems="center">
                    <ParagraphSmall marginRight={$theme.sizing.scale300}>
                      Status:
                    </ParagraphSmall>
                    {getStatusBadge(freelancerService.status)}
                  </Block>
                </Block>
              )}
            </StyledBody>
          </Card>

          <Button
            onClick={() => console.log('Continuar')}
            size="large"
            disabled={!transportService.active && !freelancerService.active}
            overrides={{
              BaseButton: { style: { width: '100%' } }
            }}
          >
            Continuar
          </Button>
        </StyledBody>
      </Card>
    </Block>
  )
}

export default ServiceActivation