# dans2019-exercise

## 준비물

본 실습 세션에서는 Mixed-gamples task 데이터(Tom et al., 2007, Science)를 사용합니다.
편의를 위해 fMRI 분석을 위한 Python 패키지인 [`fmriprep`][fmriprep]으로
전처리된 데이터(약 18 GB)를 사용하도록 하겠습니다. 팀별 프로젝트를 위해서는 데이터 전체를 다운 받으셔야 합니다. 실습 시간에는 두명의 데이터(sub-01 & sub-02)를 사용할 예정입니다. 실습을 위해서는 두명 데이터만 다운 받으셔도 됩니다. 실습 데이터를 다운 받으려면 [이 링크](https://www.dropbox.com/s/ejvxz68ghubfux3/tom2007_two_subjects.zip?dl=0)를 클릭하세요. 

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

