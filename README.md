# Neovim Pets Plugin

Este plugin em Lua traz um pequeno bichinho virtual para o Neovim 0.12. O pet aparece em uma janela flutuante e interage com o usu\xc3\xa1rio atrav\xc3\xa9s de mensagens aleat\xc3\xb3rias e emojis. Conforme voc\xc3\xaa digita palavras, o pet contabiliza a quantidade digitada e evolui, crescendo e mudando de forma.

## Instala\xc3\xa7\xc3\xa3o

Use seu gerenciador de plugins preferido. Exemplo com [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  'seuusuario/neovim-pets',
  config = function()
    require('neovim_pets').setup()
  end,
}
```

## Como funciona

- Toda vez que uma palavra \xc3\xa9 conclu\xc3\xadda no modo de inser\xc3\xa7\xc3\xa3o, o pet incrementa sua contagem interna.
- Em determinados limiares (10, 20 e 40 palavras), ele evolui para um novo est\xc3\xa1gio, exibindo um pixel art maior.
- O plugin tamb\xc3\xa9m exibe mensagens aleat\xc3\xb3rias com emojis para incentivar a digita\xc3\xa7\xc3\xa3o.

Sinta-se \xc3\xa0 vontade para personalizar os est\xc3\xa1gios do pet e as mensagens no arquivo `lua/neovim_pets/init.lua`.
