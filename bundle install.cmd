rem gem�A�b�v�f�[�g
rem call gem update --system
rem call gem update bundler

rem �ŋ߂̃A�b�v�f�[�g�̎d��
rem call gem install rubygems-update
rem call update_rubygems
rem call gem update
rem call gem cleanup

rem �R�}���h�C���X�g�[��
rem call bundle update
rem call bundle --system

rem bundler�̃C���X�g�[��
rem call gem install bundler



rem gem�t�@�C���쐬
rem    call gem build Charu.gemspec

rem �A�b�v���[�h
rem call gem push .\pkg\Charu-0.0.6.gem

rem �����ς��A�b�v���[�h
rem call bundle exec Charu GemUPLoder

rem Gem�̃C���X�g�[��
rem call gem install Charu

rem call git add file_name
call git commit -m "fast"
call git push

rem ShiccaRorl
rem aniki1119

rem �ŋ߂�gem�̍���
call bundle exec rake release

	
rem bundle install
call bundle install --path vendor/bundle
call bundle clean

	
	
REM otintin.land.waai@gmail.com

pause
