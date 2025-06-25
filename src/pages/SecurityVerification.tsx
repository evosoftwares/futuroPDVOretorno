import React, { useState, useRef } from 'react'
import { Button } from 'baseui/button'
import { Card, StyledBody } from 'baseui/card'
import { HeadingXLarge, ParagraphMedium } from 'baseui/typography'
import { FormControl } from 'baseui/form-control'
import { Input } from 'baseui/input'
import { useStyletron } from 'baseui'
import { Block } from 'baseui/block'

const SecurityVerification: React.FC = () => {
  const [css, $theme] = useStyletron()
  const [cpf, setCpf] = useState('')
  const [photo, setPhoto] = useState<string | null>(null)
  const [showCamera, setShowCamera] = useState(false)
  const videoRef = useRef<HTMLVideoElement>(null)
  const canvasRef = useRef<HTMLCanvasElement>(null)

  const formatCPF = (value: string) => {
    const numericValue = value.replace(/\D/g, '')
    return numericValue
      .replace(/(\d{3})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d)/, '$1.$2')
      .replace(/(\d{3})(\d{1,2})/, '$1-$2')
      .replace(/(-\d{2})\d+?$/, '$1')
  }

  const handleCPFChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const formatted = formatCPF(e.target.value)
    setCpf(formatted)
  }

  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ video: true })
      if (videoRef.current) {
        videoRef.current.srcObject = stream
        setShowCamera(true)
      }
    } catch (error) {
      console.error('Erro ao acessar câmera:', error)
    }
  }

  const takePhoto = () => {
    if (videoRef.current && canvasRef.current) {
      const canvas = canvasRef.current
      const video = videoRef.current
      const context = canvas.getContext('2d')
      
      canvas.width = video.videoWidth
      canvas.height = video.videoHeight
      
      if (context) {
        context.drawImage(video, 0, 0)
        const imageData = canvas.toDataURL('image/jpeg')
        setPhoto(imageData)
        
        // Parar a câmera
        const stream = video.srcObject as MediaStream
        stream.getTracks().forEach(track => track.stop())
        setShowCamera(false)
      }
    }
  }

  const handleContinue = () => {
    console.log('Continuar verificação:', { cpf, photo })
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
            marginBottom={$theme.sizing.scale600}
            color={$theme.colors.contentPrimary}
            textAlign="center"
          >
            Vamos garantir sua segurança
          </HeadingXLarge>

          <FormControl label="CPF">
            <Input
              value={cpf}
              onChange={handleCPFChange}
              placeholder="000.000.000-00"
              size="large"
              maxLength={14}
            />
          </FormControl>

          <Block marginTop={$theme.sizing.scale700}>
            <ParagraphMedium
              marginBottom={$theme.sizing.scale500}
              color={$theme.colors.contentSecondary}
              textAlign="center"
            >
              Interface da Câmera
            </ParagraphMedium>

            <Block
              display="flex"
              flexDirection="column"
              alignItems="center"
              marginBottom={$theme.sizing.scale700}
            >
              {!showCamera && !photo && (
                <Block
                  width="200px"
                  height="250px"
                  backgroundColor={$theme.colors.backgroundSecondary}
                  border={`2px dashed ${$theme.colors.borderOpaque}`}
                  borderRadius={$theme.borders.radius400}
                  display="flex"
                  alignItems="center"
                  justifyContent="center"
                  marginBottom={$theme.sizing.scale500}
                >
                  <ParagraphMedium color={$theme.colors.contentTertiary}>
                    Moldura oval para guiar o rosto
                  </ParagraphMedium>
                </Block>
              )}

              {showCamera && (
                <Block marginBottom={$theme.sizing.scale500}>
                  <video
                    ref={videoRef}
                    autoPlay
                    playsInline
                    className={css({
                      width: '200px',
                      height: '250px',
                      borderRadius: $theme.borders.radius400,
                      objectFit: 'cover'
                    })}
                  />
                  <canvas ref={canvasRef} style={{ display: 'none' }} />
                </Block>
              )}

              {photo && (
                <Block marginBottom={$theme.sizing.scale500}>
                  <img
                    src={photo}
                    alt="Foto capturada"
                    className={css({
                      width: '200px',
                      height: '250px',
                      borderRadius: $theme.borders.radius400,
                      objectFit: 'cover'
                    })}
                  />
                </Block>
              )}

              {!showCamera && !photo && (
                <Button
                  onClick={startCamera}
                  kind="secondary"
                  size="large"
                >
                  📷 Ativar Câmera
                </Button>
              )}

              {showCamera && (
                <Button
                  onClick={takePhoto}
                  size="large"
                >
                  📸 Tirar Foto
                </Button>
              )}

              {photo && (
                <Button
                  onClick={() => {
                    setPhoto(null)
                    setShowCamera(false)
                  }}
                  kind="secondary"
                  size="compact"
                >
                  🔄 Tirar Nova Foto
                </Button>
              )}
            </Block>
          </Block>

          <Button
            onClick={handleContinue}
            size="large"
            disabled={!cpf || !photo}
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

export default SecurityVerification