import pytest
import sys

sys.path.append('../src')

from database_game_reader import transform_fen

def test_transform_fen():
    assert transform_fen('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1') == {
        'black_can_castle_kingside': True,
        'black_can_castle_queenside': True,
        'en_passant_option': 'e3',
        'fullmove_number': '1',
        'halfmove_until_50_move_rule': '0',
        'position': 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR',
        'white_can_castle_kingside': True,
        'white_can_castle_queenside': True,
        'white_to_play': False
    }

    assert transform_fen('rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR w Kq - 1 1') == {
        'black_can_castle_kingside': False,
        'black_can_castle_queenside': True,
        'en_passant_option': None,
        'fullmove_number': '1',
        'halfmove_until_50_move_rule': '1',
        'position': 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR',
        'white_can_castle_kingside': True,
        'white_can_castle_queenside': False,
        'white_to_play': True,
    }

