import '../entities/cart_item.dart';

/**
 * Interface que define as operações de repositório para a entidade CartItem.
 * 
 * Seguindo o padrão DDD, esta interface define o contrato que deve ser
 * implementado por qualquer repositório que manipule itens de carrinho,
 * permitindo a inversão de dependência entre as camadas de domínio e infraestrutura.
 */
abstract class ICartItemRepository {
  /**
   * Adiciona um item ao carrinho de compras.
   * 
   * @param cartItem Item a ser adicionado ao carrinho
   * @return Future que completa com o ID do item adicionado
   */
  Future<String> addCartItem(CartItem cartItem);

  /**
   * Atualiza um item existente no carrinho de compras.
   * 
   * @param cartItem Item com as informações atualizadas
   * @return Future que completa quando a operação for concluída
   */
  Future<void> updateCartItem(CartItem cartItem);

  /**
   * Remove um item do carrinho de compras.
   * 
   * @param cartItemId ID do item a ser removido
   * @return Future que completa quando a operação for concluída
   */
  Future<void> deleteCartItem(String cartItemId);

  /**
   * Busca todos os itens do carrinho de um usuário específico.
   * 
   * @param userId ID do usuário proprietário do carrinho
   * @return Future que completa com a lista de itens do carrinho
   */
  Future<List<CartItem>> getCartItemsByUserId(String userId);

  /**
   * Busca um item específico do carrinho pelo ID.
   * 
   * @param cartItemId ID do item a ser buscado
   * @return Future que completa com o item encontrado ou null
   */
  Future<CartItem?> getCartItemById(String cartItemId);

  /**
   * Limpa todos os itens do carrinho de um usuário específico.
   * 
   * @param userId ID do usuário proprietário do carrinho
   * @return Future que completa quando a operação for concluída
   */
  Future<void> clearCart(String userId);
}