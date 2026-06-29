# AnalysisFrame 기준 UML 클래스 다이어그램

근거 파일:

- `D:\swa\TimeGrapher-Net\src\TimeGrapher.Core\Shared\AnalysisFrame.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.Core\Shared\BeatMetricsHistorySnapshot.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.Core\Shared\BeatMetricsTypes.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.Core\Shared\BeatSegmentsSnapshot.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.Core\Shared\SignalQualityAssessment.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.Core\Shared\PixelBuffer.cs`

발표 포인트:

- `AnalysisFrame`은 한 번의 analysis pass 결과를 UI update 단위로 묶는 중심 DTO다.
- 그래프 series, marker, metrics, beat segment, image, signal-quality annotation을 한 frame에 실어 보낸다.
- 이 구조 때문에 여러 renderer가 같은 frame을 소비하고, QAS-4 display consistency를 설명할 수 있다.
- `SignalQualityAssessment`는 nullable annotation이며 advisory only다. beat event 생성/삭제/retime 경로에는 들어가지 않는다.

UML 표기:

- ◆ composition: frame payload로 직접 보유되는 관계.
- ◇ aggregation/reference: nullable snapshot 또는 공유 가능한 이미지/annotation.
- `+ public`, `~ internal`, `- private`.
