# dans2019-exercise

## 필수 프로그램

1. hBayesDM R package 설치. 자세한 설치법은 [이 링크](https://github.com/CCS-Lab/hBayesDM)를 참고하세요. rstan이 제대로 설치가 안되서 hBayesDM 제대로 안 될 경우가 많으니까 설치가 제대로 됐는지 꼭 확인하세요. rstan이 제대로 설치가 되었는지 [여기](https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started)에 가서 Eight Schools 예제가 돌아가는지 확인해 주세요. 

```r
install.packages("hBayesDM", dependencies=T)  # Install from CRAN
```

2. MATLAB 및 SPM12 설치

수업 전에 `matlab_functions` 폴더 안에 있는 `tsvread.m` 파일과 SPM12를 꼭 설치(`Set Path`로 가서 추가)하셔야 합니다. 동일 폴더 안에 있는 [xjview](http://www.alivelearn.net/xjview/)도 권장합니다 (그냥 같이 설치 하세요). 

## 준비물

본 실습 세션에서는 Mixed-gamples task 데이터(Tom et al., 2007, Science)를 사용합니다.
편의를 위해 fMRI 분석을 위한 Python 패키지인 [`fmriprep`][fmriprep]으로
전처리된 데이터(약 18 GB)를 사용하도록 하겠습니다. 팀별 프로젝트를 위해서는 데이터 전체를 다운 받으셔야 합니다. 화요일 수업의 실습 시간에는 두명의 데이터(sub-01 & sub-02)를 사용할 예정입니다. 실습을 위해서는 두명 데이터만 다운 받으셔도 됩니다. 실습 데이터(2명 데이터)를 다운 받으려면 [이 링크](https://www.dropbox.com/s/ejvxz68ghubfux3/tom2007_two_subjects.zip?dl=0)를 클릭하세요. 

전체 데이터(18GB)는 OpenNeuro를 통해 [이 링크][data]에 공유되어 있으며,
다음의 두 가지 방법 중 하나로 다운로드 받으실 수 있습니다.

[data]: https://openneuro.org/datasets/ds000005/versions/00001
[fmriprep]: https://github.com/poldracklab/fmriprep

### (easy) 웹 사이트에서 다운로드

[이 링크][data]로 들어가시면 우측에 Analysis 탭이 있습니다.
그 중 `fmriprep` > `poldlack/fmriprep:1.0.0-rc6` > `Results` 메뉴로 들어가시면
`Download all` 버튼을 눌러 다운로드 받으실 수 있습니다.

### (advanced) AWS CLI를 이용하여 다운로드

이후 OpenNeuro를 통해 데이터를 자주 받으시려는 경우 AWS S3에서 데이터를 받는
것이 편리할 수 있습니다. [AWS CLI (Command Line Interface)][aws-cli]를 이용하면
이를 커맨드 라인에서 다운로드를 받을 수 있습니다.

[aws-cli]: https://aws.amazon.com/ko/cli/

- **Windows**: [링크][aws-cli]로 들어가시어 설치 파일을 실행하여 설치.
- **Mac or Linux**: 터미널에서 `pip install awscli`를 실행.

AWS CLI가 설치되셨으면 터미널 혹은 커맨드 프롬프트(`cmd`)에서 다음의 명령어를
실행시켜 데이터를 다운로드 받을 수 있습니다.

```bash
aws --no-sign-request s3 sync s3://openneuro.outputs/fb711c8cc868b565f709f5690e408cb4/51598f96-48b1-44df-b775-e0ad10bd1e29 tom-data
```
## 수업 슬라이드

수업 전에 강사가 내용을 약간씩 수정할 수 있으므로 수업 시작 전에 최종본을 확인하세요. 이 [Dropbox link](https://www.dropbox.com/sh/4te1gco5aih47hf/AACsEKjO2qBRsi17vprhA3pta?dl=0)로 가시면 up-to-date된 수업 슬라이드를 다운 받을 수 있습니다. 
