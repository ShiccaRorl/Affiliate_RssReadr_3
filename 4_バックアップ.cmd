REM @echo off


REM date���ϐ�������t�̐��������𒊏o����

REM �@�ȏ�̏������g���΁A�u2015/07/01�v�̂悤�ȕ�����̓�����date�ϐ����琔���̕��������𔲂��o���ɂ́A

REM     �N�F �擪����A4������
REM     ���F �擪���6�����ڂ���A2������
REM     ���F �擪���9�����ڂ���A2������

REM %date:~0,4%%date:~5,2%%date:~8,2%


REM ���k

REM C:\7za.exe a C:\���k��t�@�C����.zip C:\���k�O�t�@�C����.txt


REM 7-Zip [64] 4.65  Copyright (c) 1999-2009 Igor Pavlov  2009-02-03

REM �g�p�@: 7z <�R�}���h> [<�X�C�b�`>...] <���Ƀt�@�C��> [<���Ƀt�@�C��>...]
REM  [<@���X�g�t�@�C��...>]

REM <�R�}���h>
REM  a: ���ɂɃt�@�C����ǉ�����BAdd files to archive
REM  b: �x���`�}�[�N�BBenchmark
REM  d: ���ɂ���t�@�C�����폜����BDelete files from archive
REM  e: ���ɂ���t�@�C�������o���i�f�B���N�g�����Ȃ��j�BExtract files from archive (without using directory names)
REM  l: ���ɓ��̓��e�ꗗ��\���BList contents of archive
REM  t: ���ɂ̊��S�����e�X�g����BTest integrity of archive
REM  u: ���ɂ̃t�@�C�����X�V����BUpdate files to archive
REM  x: �t���p�X�Ńt�@�C�������o���BeXtract files with full paths
REM <�X�C�b�`>
REM  -ai[r[-|0]]{@���X�g�t�@�C��|!���C���h�J�[�h}: ���ɂɊ܂߂�B Include archives
REM  -ax[r[-|0]]{@���X�g�t�@�C��|!���C���h�J�[�h}: ���ɂ��珜�O����BeXclude archives
REM  -bd: �p�[�Z���g�\���𖳌��ɂ���BDisable percentage indicator
REM  -i[r[-|0]]{@���X�g�t�@�C��|!���C���h�J�[�h}: �t�@�C�������܂߂�BInclude filenames
REM  -m{�p�����[�^}: ���k���@��ݒ肷��Bset compression Method
REM  -o{�f�B���N�g��}: �o�̓f�B���N�g����ݒ肷��Bset Output directory
REM  -p{�p�X���[�h}: �p�X���[�h��ݒ肷��Bset Password
REM  -r[-|0]: �T�u�f�B���N�g�����ċA�I�Ɏ��s����BRecurse subdirectories
REM  -scs{UTF-8 | WIN | DOS}: �ꗗ�t�@�C���̕����R�[�h��ݒ肷��Bset charset for list files
REM  -sfx[{���O}]: ���ȉ𓀏��ɂ��쐬����BCreate SFX archive
REM  -si[{���O}]: �W�����͂���f�[�^��ǂށBread data from stdin
REM  -slt: ���i���X�g�j�R�}���h�ɋZ�p����\������Bshow technical information for l (List) command
REM  -so: �f�[�^��W���o�͂ɏ����Bwrite data to stdout
REM  -ssc[-]: �啶���Ə���������ʂ���Bset sensitive case mode
REM  -ssw: ���L�t�@�C�������k����Bcompress shared files
REM  -t{Type}: ���ɂ̃^�C�v��ݒ肷��BSet type of archive
REM  -v{Size}[b|k|m|g]: �{�����[�����쐬����BCreate volumes
REM  -u[-][p#][q#][r#][x#][y#][z#][!newArchiveName]: �X�V�I�v�V�����BUpdate options
REM  -w[{path}]: ��ƃf�B���N�g�����w�肷��B�󗓂Ȃ�ꎞ�f�B���N�g���Ƃ݂Ȃ��Bassign Work directory. Empty path means a temporary directory
REM  -x[r[-|0]]]{@���X�g�t�@�C��|!���C���h�J�[�h}: �t�@�C�������s����BeXclude filenames
REM  -y: �����Yes�Ɠ�������̂Ƃ��Ď��s����Bassume Yes on all queries



.\..\tool\7z\7za.exe a C:\Affiliate_RssReadr_3\Affiliate_Data.SQLite3_%date:~0,4%-%date:~5,2%-%date:~8,2%.7z C:\Affiliate_RssReadr_3\Affiliate_Data.SQLite3 -r -w.\ -ssc -ssw -mx=9 -mfb=128 -y
.\..\tool\7z\7za.exe a C:\Affiliate_RssReadr_3\RssData.SQLite3_%date:~0,4%-%date:~5,2%-%date:~8,2%.7z C:\Affiliate_RssReadr_3\RssData.SQLite3 -r -w.\ -ssc -ssw -mx=9 -mfb=128 -y
